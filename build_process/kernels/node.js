'use strict';

// REMOVE_START_WHEN:MINIMAL_BUILD,PROFILING_BUILD
//
// The following is for debugging and sanity checking. Not needed at runtime.

const makeKindRef = (kindName, gitUrl, gitRef, contextDir, manifestPath) => {
  return {
    contextDir: contextDir,
    manifestPath: manifestPath,
    kindName: kindName,
    gitRef: gitRef,
    gitUrl: gitUrl
  };
};

const prepareLocalKind = (pathToLocalGitRepo, rootDir, kindRef) => {
  const kindIdHash = getKindIdHash(kindRef);
  const localRefDir = path.dirname(path.join(rootDir, kindIdHash, kindRef.manifestPath));
  const localGitDir = path.join(pathToLocalGitRepo, kindRef.contextDir);

  console.log('Preparing local kind', localGitDir, localRefDir);

  fs.mkdirSync(path.dirname(localRefDir), {
    recursive: true
  });

  if (!fs.existsSync(localRefDir)) {
    fs.symlinkSync(localGitDir, localRefDir);
  }
};

const preflightCheck = (rootDir, kindRefs, topLevelKindName) => {
  console.log('Preflight check', rootDir, kindRefs, topLevelKindName);

  if (!fs.existsSync(rootDir) || !fs.statSync(rootDir).isDirectory()) {
    throw new Error('Root directory does not exist', rootDir);
  }

  if (kindRefs[topLevelKindName] === undefined) {
    throw new Error('Top level kind name not found', topLevelKindName);
  }

  Object.keys(kindRefs).forEach((key) => {
    console.log('Checking kind', key);
    const kindRef = kindRefs[key];

    checkKindReference(kindRef);

    const manifest = getManifestFromKindRef(rootDir, kindRef);
    console.log('Checking manifest', manifest);

    checkKindManifest(rootDir, kindRef, manifest);

    const entrypointPath = getAbsPath(rootDir, kindRef, manifest.entrypoint);
    const entrypoint = require(entrypointPath);

    switch (manifest.kindType) {
      case 'composite':
        console.log('Checking composite entrypoint', entrypoint);
        let metadata;

        if (typeof entrypoint.kindName !== 'string') {
          throw new Error('entrypoint.kindName must be a string and is not.');
        }
        if (typeof entrypoint.wireCount !== 'number') {
          throw new Error('entrypoint.wireCount must be a number and is not.');
        }
        if (!isPartDefinition(entrypoint.self)) {
          throw new Error('entrypoint.self must be part and is not.');
        }
        if (!isArrayOfParts(entrypoint.parts)) {
          throw new Error('entrypoint.parts must be an array of parts and is not.');
        }
        try {
          metadata = JSON.parse(entrypoint.metaData);
        } catch (e) {
          throw new Error('entrypoint.metaData must be a JSON string and is not.');
        }
        if (!(metadata instanceof Array)) {
          throw new Error('entrypoint.metaData after parsing must be an array and is not.');
        }
        metadata.forEach((kindRef) => {
          checkKindReference(kindRef);
        });
        const entrypointInPins = Object.keys(entrypoint.self.inMap);
        const entrypointOutPins = Object.keys(entrypoint.self.outMap);
        if (!areArraysIdentical(manifest.inPins, entrypointInPins)) {
          throw new Error('entrypoint.self.inMaps must mirror manifest.inPins and does not.');
        }
        if (!areArraysIdentical(manifest.outPins, entrypointOutPins)) {
          throw new Error('entrypoint.self.outMaps must mirror manifest.outPins and does not.');
        }
        break;

      case 'leaf':
        console.log('Checking leaf entrypoint');

        if (typeof entrypoint.main !== 'function') {
          throw new Error('entrypoint.main must be a function and is not.');
        }
        break;
    }
  });
};

const checkKindReference = (kindRef) => {
  if (typeof kindRef !== 'object') {
    throw new Error('ref must be an object and is not.');
  }
  if (typeof kindRef.contextDir !== 'string') {
    throw new Error('contextDir must be a string and is not.');
  }
  if (typeof kindRef.manifestPath !== 'string') {
    throw new Error('manifestPath must be a string and is not.');
  }
  if (typeof kindRef.kindName !== 'string') {
    throw new Error('kindName must be a string and is not.');
  }
  if (typeof kindRef.gitRef !== 'string') {
    throw new Error('gitRef must be a string and is not.');
  }
  if (typeof kindRef.gitUrl !== 'string') {
    throw new Error('gitUrl must be a string and is not.');
  }
};

const checkKindManifest = (rootDir, kindRef, manifest) => {
  const entrypointPath = getAbsPath(rootDir, kindRef, manifest.entrypoint);
  console.log('Checking kind manifest', rootDir, kindRef, manifest, entrypointPath);

  if (!fs.existsSync(entrypointPath) || !fs.statSync(entrypointPath).isFile()) {
    throw new Error('manifest.entrypoint must be a file and is not.');
  }
  if (['composite', 'leaf'].indexOf(manifest.kindType) < 0) {
    throw new Error('manifest.kindType is not valid');
  }
  if (manifest.platform !== 'nodejs') {
    throw new Error('manifest.platform must be "nodejs" and is not.');
  }
  if (!(manifest.inPins instanceof Array)) {
    throw new Error('manifest.inPins must be an array and is not.');
  }
  manifest.inPins.forEach((inPin) => {
    if (typeof inPin !== 'string') {
      throw new Error('manifest.inPin must be a string and is not.');
    }
  });
  if (!(manifest.outPins instanceof Array)) {
    throw new Error('manifest.outPins must be an array and is not.');
  }
  manifest.outPins.forEach((outPin) => {
    if (typeof outPin !== 'string') {
      throw new Error('manifest.outPin must be a string and is not.');
    }
  });
};

const areArraysIdentical = (x, y) => {
  if (x.length !== y.length) {
    return false;
  }

  const xSorted = x.sort();
  const ySorted = y.sort();

  for (var i = 0, l = xSorted.length; i < l; i++) {
    if (xSorted[i] !== ySorted[i]) {
      return false;
    }
  }

  return true;
};

const isArrayOfArrayOfNumbers = (arr) => {
  var i, l, j, m;

  if (!(arr instanceof Array)) {
    return false;
  } else {
    for (i = 0, l = arr.length; i < l; i++) {
      if (!(arr[i] instanceof Array)) {
        return false;
      } else {
        for (j = 0, m = arr[i].length; j < m; j++) {
          if (typeof arr[i][j] !== 'number') {
            return false;
          }
        }
      }
    }
  }

  return true;
};

const isMapOfStringToNumber = (map) => {
  let qualified = true;

  Object.keys(map).forEach((key) => {
    if (typeof key !== 'string') {
      qualified = false;
    }

    if (typeof map[key] !== 'number') {
      qualified = false;
    }
  });

  return qualified;
};

const isPartDefinition = (part) => {
  const hasKindName = typeof part.kindName === 'string';
  const hasPartName = typeof part.partName === 'string';
  const hasInCount = typeof part.inCount === 'number';
  const hasOutCount = typeof part.outCount === 'number';
  const hasInPins = isArrayOfArrayOfNumbers(part.inPins);
  const hasOutPins = isArrayOfArrayOfNumbers(part.outPins);
  const hasInMap = isMapOfStringToNumber(part.inMap);
  const hasOutMap = isMapOfStringToNumber(part.outMap);

  return hasKindName && hasPartName && hasInCount && hasOutCount && hasInPins && hasOutPins && hasInMap && hasOutMap;
};

const isArrayOfParts = (parts) => {
  var i, l;

  if (!(parts instanceof Array)) {
    return false;
  }

  for (i = 0, l = parts.length; i < l; i++) {
    if (!(isPartDefinition(parts[i]))) {
      return false;
    }
  }

  return true;
};

const getKindIdHash = (kindRef) => {
  const kindId = [kindRef.gitUrl, kindRef.gitRef, kindRef.contextDir, kindRef.manifestPath].join('|');
  const kindIdHash = crypto.createHash('sha256').update(kindId).digest('hex');
  return kindIdHash;
};

// REMOVE_END_WHEN:MINIMAL_BUILD,PROFILING_BUILD

const fs = require('fs');
const crypto = require('crypto');
const path = require('path');

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

const getAbsPath = (rootDir, kindRef, relPath) => {
  const kindIdHash = getKindIdHash(kindRef);
  return path.join(rootDir, kindIdHash, relPath);
};

// Load the manifest given a kind reference object. See README.md for the
// structure of a reference object.
const getManifestFromKindRef = (rootDir, kindRef) => {
  const kindIdHash = getKindIdHash(kindRef);
  console.log('Getting manifest from reference', kindIdHash, kindRef); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
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
    console.log('initComposite', kindDef); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

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
    // We need a way to know when to flush the Sinks.
    var flushSinks = false;

    const send = (originatingPartIndex, pinIndex, packet, releaseImmediately) => {
      console.log('internal send', kindDef.kindName, originatingPartIndex, pinIndex, packet); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      outQueue[originatingPartIndex].push(OutEvent(packet, originatingPartIndex, pinIndex));

      if (releaseImmediately === true) {
        release(originatingPartIndex);
      }
    };

    const pushToInQueue = (wireNumber, outEvent) => {
      const receivers = wireToReceivers[wireNumber];
      const sinks = wireToSinks[wireNumber];
      console.log('pushToInQueue', kindDef.kindName, wireNumber, outEvent, receivers, sinks); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      var i, l;
      var receiver;

      // For sinks
      for (i = 0, l = sinks.length; i < l; i++) {
console.log('kktest-0000', sinks, i);
        parentSend(sinks[i], outEvent.packet);
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
      console.log('release', kindDef.kindName, partIndex, queue); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

      while (queue.length > 0) {
        outEvent = queue.shift();
        console.log('release processing event', partPinToWires, kindDef.kindName, outEvent); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        wires = partPinToWires[outEvent.from][outEvent.pin];
        for (i = 0, l = wires.length; i < l; i++) {
          pushToInQueue(wires[i], outEvent);
        }
      }

      setTimeout(dispatch, 0);
    };

    const runPart = (partIndex, incomingPin, incomingPacket) => {
      console.log('runPart', kindDef.kindName, partIndex, incomingPin, incomingPacket); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

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
        console.log('incoming pin not found', kindDef.kindName, partIndex, incomingPin);
      }
      // REMOVE_END_WHEN:MINIMAL_BUILD,PROFILING_BUILD

      // Run the part's main function.
      console.log('runPart before', kindDef.kindName, partIndex, incomingPinName, incomingPacket); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      partMains[partIndex](incomingPinName, incomingPacket, (outgoingPin, outgoingPacket, releaseImmediately) => {
        console.log('runPart after', kindDef.kindName, partIndex, outgoingPin, outgoingPacket); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

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
          console.log('outgoing pin not found', kindDef.kindName, partIndex, outgoingPin);
        }
        // REMOVE_END_WHEN:MINIMAL_BUILD,PROFILING_BUILD

        send(partIndex, outgoingPinIndex, outgoingPacket, releaseImmediately);
      });
    };

    const dispatch = () => {
      console.log('dispatch', kindDef.kindName); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      var partIndex;
      var queue;
      var inEvent;

      while (readyParts.length > 0) {
        partIndex = readyParts.shift();
        queue = inQueue[partIndex];

        console.log('dispatch start', kindDef.kindName, partIndex); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        while (queue.length > 0) {
          inEvent = queue.pop();
          console.log('dispatch event', kindDef.kindName, partIndex, inEvent); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
          runPart(partIndex, inEvent.pin, inEvent.packet);
        }

        release(partIndex);
      }

      if (flushSinks) {
        console.log('dispatch release parent', kindDef.kindName); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
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
    for (i = 0, l = compositeOutPins.length; i < l; i++) {
      wireToSinks[compositeOutPins[i]].push(i);
    }

    // Prepare the parts.
    for (i = 0, l = partCount; i < l; i++) {
      console.log('preparing a part', kindDef.kindName, i); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      part = kindDef.parts[i];
      parts[i] = part;
      inQueue[i] = [];
      outQueue[i] = [];

      for (m = 0, n = part.inPins.length; m < n; m++) {
        console.log('preparing a input pin', kindDef.kindName, i, m, wireToReceivers); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
        wireNumber = part.inPins[m];
        wireToReceivers[wireNumber].push({
          part: i,
          pin: m
        });
      }

      // The "main" of a part is just a wrapper so that we could provide
      // specific send and release subroutines to the "main" in the entrypoint
      // subroutine specified in the kind definition.
      partMains[i] = ((partIndex) => {
        const sendFromThisPart = (pin, packet) => {
// TODO: Refactor this
          let pinIndex;
          if (typeof pin === 'string') {
            pinIndex = outPins[partIndex].indexOf(pin);
          } else {
            pinIndex = pin;
          }
          send(partIndex, pinIndex, packet);
        };
        const releaseFromThisPart = () => {
          release(partIndex);
        };
        return initPart(part.kindName, sendFromThisPart, releaseFromThisPart);
      })(i);
      console.log('saving kind pins', kindPins, kindDef.kindName, part.kindName, i); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      inPins[i] = kindPins[part.kindName].inPins;
      outPins[i] = kindPins[part.kindName].outPins;
    }

    // The parent of this composite calls this like a leaf part's function with
    // the same arguments. This allows the outer composites to be able to treat
    // composites and leaf parts in the same way.
    //
    // Whenever there is a packet coming from the outer composite, push it
    // directly to the queue and wait for dispatch.
    return (sourceName, packet, send) => {
      const sourceNumber = compositeInMap[sourceName];
      const sourceWireNumber = compositeInPins[sourceNumber];
      console.log('composite receives packet', kindDef.kindName, sourceName, sourceNumber, packet, sourceWireNumber); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
      // No action if the following is not true. It'd be a no-connection scenario.
      if (sourceWireNumber) {
        pushToInQueue(sourceWireNumber, OutEvent(packet));
      }
      setTimeout(dispatch, 0);
    };
  };

  // This takes a leaf definition (see README), extract the input and output pin
  // definitions, and the main and bootstrap routines to be invoked later.
  const initLeaf = (entrypoint, send, release) => {
    console.log('initLeaf'); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD

    // Save bootstrap function to be called at the end of initialization.
    if (typeof entrypoint.bootstrap === 'function') {
      leafPartBootstraps.push(() => entrypoint.bootstrap(send, release));
    }

    return entrypoint.main;
  };

  const initPart = (kindName, send, release) => {
    console.log('initPart', kindName); // REMOVE_LINE_WHEN:MINIMAL_BUILD,PROFILING_BUILD
    const kindRef = kindRefs[kindName];
    const manifest = getManifestFromKindRef(rootDir, kindRef);
    const entrypointPath = getAbsPath(rootDir, kindRef, manifest.entrypoint);

    // Clear Node.js require cache to force each instance of the leaf type to be
    // separate from one another.
    for (var key in require.cache) {
// TODO: Delete only the relevant ones.
console.log('Cache key', key);
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

if (typeof module === 'object') {
  exports.runKernel = runKernel;
  // REMOVE_START_WHEN:MINIMAL_BUILD,PROFILING_BUILD
  exports.getKindIdHash = getKindIdHash;
  exports.preflightCheck = preflightCheck;
  exports.makeKindRef = makeKindRef;
  exports.prepareLocalKind = prepareLocalKind;
  // REMOVE_END_WHEN:MINIMAL_BUILD,PROFILING_BUILD
}
