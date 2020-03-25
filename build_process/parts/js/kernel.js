'use strict';

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const kindManifests = {};
const kindPins = {};
const leafPartBootstraps = [];

const OutEvent = (packet, from, pin) => {
  return {
    packet: packet,
    from: from,
    pin: pin
  };
};

const getKindIdHash = (kindRef) => {
  const kindId = [kindRef.gitUrl, kindRef.gitRef, path.join(kindRef.contextDir, kindRef.manifestPath)].join('|');
  const kindIdHash = crypto.createHash('sha256').update(kindId).digest('hex');
  return kindIdHash;
};

const getAbsPath = (rootDir, kindRef, relPath) => {
  const kindIdHash = getKindIdHash(kindRef);
  return path.join(rootDir, kindIdHash, relPath);
};

// Load the manifest given a kind reference object. See README.md for the
// structure of a reference object.
const getManifestFromKindRef = (rootDir, kindRef) => {
  const kindIdHash = getKindIdHash(kindRef);
  console.log('Getting manifest from reference:', kindIdHash, kindRef); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
  let manifest;

  if (kindManifests[kindIdHash] !== undefined) {
    manifest = kindManifests[kindIdHash];
  } else {
    const manifestPath = getAbsPath(rootDir, kindRef, kindRef.manifestPath);
    manifest = require(manifestPath);
    kindManifests[kindIdHash] = manifest;
    // TODO: We need to somehow make kindIdHash calculable within a composite so that we could support the same kind name for multiple kinds. One idea is to have the reference object spec to include a universal kindId and do away with kindIdHash.
    kindPins[kindRef.kindName] = {
      inPins: manifest.inPins,
      outPins: manifest.outPins
    };
  }

  return manifest;
};

const runKernel = (rootDir, kindRefs, topLevelKindName) => {
  // parentSend - This is the `send()` subroutine to send packets via the sinks
  //   of this composite.
  // parentRelease - This is how the Composite triggers the parent composite to
  //   process any packet sent to this composite's sinks.
  const initComposite = (kindDef, parentSend, parentRelease) => {
    console.log('initComposite:', kindDef); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

    const wireCount = kindDef.wireCount;
    const partCount = kindDef.parts.length;
    // Maps part index in `kindDef.parts` to part object
    const parts = [];
    // The main entry points of the parts, indexed by part index
    const partMains = [];
    // Maps wire number to the parts that are on the receiving end of the wire
    const wireToReceivers = [];
    // The input queues of the parts, indexed by the part index. There is
    // exactly one input queue for each part.
    const inQueue = [];
    // The output queue is an array of arrays, first indexed by part index,
    // then by the part's pin index. There is exactly one output queue for each
    // part.
    const outQueue = [];
    // Input pin translation from pin names (strings) to pin indexes (numbers)
    // of the constituent parts.
    const inPins = [];
    // Output pin translation from pin names (strings) to pin indexes (numbers)
    // of the constituent parts.
    const outPins = [];
    const compositeInPins = kindDef.self.inPins;
    const compositeOutPins = kindDef.self.outPins;
    const compositeInMap = kindDef.self.inMap;
    const compositeOutMap = kindDef.self.outMap;
    // Indexes of the parts that can be activated
    const readyParts = [];
    // Map wire number to sink numbers. Note that one wire may be attached to
    // multiple sinks.
    const wireToSinks = [];
    // Map a tuple of part ID and output pin ID to wires. Note that each tuple
    // may point to multiple wires.
    const partPinToWires = [];
    // Map sink number to the sink's pin name. This is needed to send packets
    // to the parent.
    const sinkToPinNames = [];
    // We need a way to know when to flush the Sinks.
    var flushSinks = false;

    const send = (originatingPartIndex, pinIndex, packet, releaseImmediately) => {
      console.log('internal send:', kindDef.kindName, originatingPartIndex, pinIndex, packet, releaseImmediately); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      outQueue[originatingPartIndex].push(OutEvent(packet, originatingPartIndex, pinIndex));

      if (releaseImmediately === true) {
        release(originatingPartIndex);
      }
    };

    const pushToInQueue = (wireNumber, outEvent) => {
      const receivers = wireToReceivers[wireNumber];
      const sinks = wireToSinks[wireNumber];
      console.log('pushToInQueue:', kindDef.kindName, wireNumber, outEvent, receivers, sinks); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      var i, l;
      var receiver;

      // For sinks
      for (i = 0, l = sinks.length; i < l; i++) {
console.log('Sending to sink:', kindDef.kindName, wireNumber, i, sinks[i], outEvent); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        parentSend(sinkToPinNames[sinks[i]], outEvent.packet);
        flushSinks = true;
      }

      // For other Parts in the Composite
      for (i = 0, l = receivers.length; i < l; i++) {
        receiver = receivers[i];
        readyParts.push(receiver.part);
        inQueue[receiver.part].push({
          pin: receiver.pin,
          packet: outEvent.packet
        });
      }
    };

    const release = (partIndex) => {
      var i, l;
      var outEvent;
      var wires;
      const queue = outQueue[partIndex];
      console.log('release:', kindDef.kindName, partIndex, queue); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

      while (queue.length > 0) {
        outEvent = queue.shift();
        console.log('release processing event:', outEvent, partPinToWires[outEvent.from]); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        wires = partPinToWires[outEvent.from][outEvent.pin];
        for (i = 0, l = wires.length; i < l; i++) {
          pushToInQueue(wires[i], outEvent);
        }
      }

      setTimeout(dispatch, 0);
    };

    const runPart = (partIndex, incomingPin, incomingPacket) => {
      console.log('runPart:', kindDef.kindName, partIndex, incomingPin, incomingPacket); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

// TODO: Is it necessary to translate from both?
// TODO: Refactor this
      // Translate from pin index to pin name.
      let incomingPinName;
      if (typeof incomingPin === 'string') {
        incomingPinName = incomingPin;
      } else {
        incomingPinName = inPins[partIndex][incomingPin];
      }
      // REMOVE_START_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      if (incomingPinName === undefined) {
        console.log('incoming pin not found:', kindDef.kindName, partIndex, incomingPin);
      }
      // REMOVE_END_WHEN:MINIMAL_BUILD,PROFILING_BUILD

      // Run the part's main function.
      console.log('runPart before:', kindDef.kindName, partIndex, incomingPinName, incomingPacket); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      partMains[partIndex](incomingPinName, incomingPacket, (outgoingPin, outgoingPacket, releaseImmediately) => {
        console.log('runPart after:', kindDef.kindName, partIndex, outgoingPin, outgoingPacket); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

// TODO: Refactor this
        // Translate pin name to pin index.
        let outgoingPinIndex;
        if (typeof outgoingPin === 'string') {
          outgoingPinIndex = outPins[partIndex].indexOf(outgoingPin);
        } else {
          outgoingPinIndex = outgoingPin;
        }
        // REMOVE_START_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        if (outgoingPinIndex < 0) {
          console.log('outgoing pin not found:', kindDef.kindName, partIndex, outgoingPin);
        }
        // REMOVE_END_WHEN:MINIMAL_BUILD,PROFILING_BUILD

        send(partIndex, outgoingPinIndex, outgoingPacket, releaseImmediately);
      });
    };

    const dispatch = () => {
      console.log('dispatch:', kindDef.kindName, readyParts.length); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      var partIndex;
      var queue;
      var inEvent;

      while (readyParts.length > 0) {
        partIndex = readyParts.shift();
        queue = inQueue[partIndex];

        console.log('dispatch start:', kindDef.kindName, partIndex); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        while (queue.length > 0) {
          inEvent = queue.pop();
          console.log('dispatch event:', kindDef.kindName, partIndex, inEvent); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
          runPart(partIndex, inEvent.pin, inEvent.packet);
        }

        release(partIndex);
      }

      if (flushSinks) {
        console.log('dispatch release parent:', kindDef.kindName); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        parentRelease();
      }
    };

    var i, l, m, n, o, p;
    var part;
    var wireNumber;
    var wires;
    var outPinCount;

    // Initialize arrays.
    for (i = 0, l = wireCount; i < l; i++) {
      wireToSinks[i] = [];
    }
    for (i = 0, l = wireCount; i < l; i++) {
      wireToReceivers[i] = [];
    }
    for (i = 0, l = partCount; i < l; i++) {
      partPinToWires[i] = kindDef.parts[i].outPins;
    }

    // Prepare the sinks.
    compositeOutPins.forEach((wires, pinIndex) => {
      wires.forEach((wireNumber) => {
        wireToSinks[wireNumber].push(pinIndex);
      });
    });

    Object.keys(compositeOutMap).map((sinkPinName) => {
      const index = compositeOutMap[sinkPinName];
      sinkToPinNames[index] = sinkPinName;
    });

    // Prepare the parts.
    kindDef.parts.forEach((part, i) => {
      console.log('preparing a part:', kindDef.kindName, i, kindDef.parts[i]); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      parts[i] = part;
      inQueue[i] = [];
      outQueue[i] = [];

      part.inPins.forEach((wireNumbers, m) => {
        console.log('preparing a input pin:', kindDef.kindName, wireNumbers, wireToReceivers); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        wireNumbers.forEach((wireNumber) => {
          wireToReceivers[wireNumber].push({
            part: i,
            pin: m
          });
        });
      });

      // The "main" of a part is just a wrapper so that we could provide
      // specific send and release subroutines to the "main" in the entrypoint
      // subroutine specified in the kind definition.
      partMains[i] = ((partIndex) => {
        const sendFromThisPart = (pinName, packet) => {
          const pinIndex = outPins[partIndex].indexOf(pinName);
          send(partIndex, pinIndex, packet);
        };
        const releaseFromThisPart = () => {
          release(partIndex);
        };
        return initPart(part.kindName, sendFromThisPart, releaseFromThisPart);
      })(i);

      console.log('saving kind pins:', kindPins, kindDef.kindName, part.kindName, i); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      inPins[i] = [];
       Object.keys(part.inMap).map((pinName) => {
         const index = part.inMap[pinName];
         inPins[i][index] = pinName;
      });
      outPins[i] = [];
       Object.keys(part.outMap).map((pinName) => {
         const index = part.outMap[pinName];
         outPins[i][index] = pinName;
      });
    });

    // The parent of this composite calls this like a leaf part's function with
    // the same arguments. This allows the outer composites to be able to treat
    // composites and leaf parts in the same way.
    //
    // Whenever there is a packet coming from the outer composite, push it
    // directly to the queue and wait for dispatch.
    return (sourceName, packet, send) => {
      const sourceNumber = compositeInMap[sourceName];
      const sourceWireNumbers = compositeInPins[sourceNumber];
console.log('composite receives packet:', kindDef.kindName, sourceName, sourceNumber, sourceWireNumbers, packet); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      // No action if the following is not true. It'd be a no-connection scenario.
      if (sourceWireNumbers) {
        sourceWireNumbers.forEach((wireNumber) => {
          pushToInQueue(wireNumber, OutEvent(packet));
        });
      }
      setTimeout(dispatch, 0);
    };
  };

  // This takes a leaf definition (see README), extract the input and output pin
  // definitions, and the main and bootstrap routines to be invoked later.
  const initLeaf = (entrypoint, send, release) => {
    console.log('initLeaf:'); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

    // Save bootstrap function to be called at the end of initialization.
    if (typeof entrypoint.bootstrap === 'function') {
      leafPartBootstraps.push(() => entrypoint.bootstrap(send, release));
    }

    return entrypoint.main;
  };

  const initPart = (kindName, send, release) => {
    console.log('initPart:', kindName); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
    const kindRef = kindRefs[kindName];
    const manifest = getManifestFromKindRef(rootDir, kindRef);
    const entrypointPath = getAbsPath(rootDir, kindRef, manifest.entrypoint);

    // Clear Node.js require cache to force each instance of the leaf type to be
    // separate from one another.
    for (var key in require.cache) {
// TODO: Delete only the relevant ones.
console.log('Cache key:', key);
      delete require.cache[key];
    }

    const entrypoint = require(entrypointPath);

    switch (manifest.kindType) {
      case 'leaf':
        return initLeaf(entrypoint, send, release);
        break;
      case 'composite':
        return initComposite(entrypoint, send, release);
        break;
    }
  };

  initPart(topLevelKindName);
  leafPartBootstraps.forEach((bootstrap) => bootstrap());
};

exports.runKernel = runKernel;
exports.getKindIdHash = getKindIdHash;
exports.getAbsPath = getAbsPath;
exports.getManifestFromKindRef = getManifestFromKindRef;
