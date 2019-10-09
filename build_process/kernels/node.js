const runKernel = (() => {
  'use strict';

  const fs = require('fs');
  const crypto = require('crypto');

  function PartPinTuple(part, pin) {
    this.part = part;
    this.pin = pin;
  }

  function OutEvent(packet, from, pin) {
    this.packet = packet;
    this.from = from;
    this.pin = pin;
  }

  function Kind(definition, inPins, outPins) {
    this.definition = definition;
    this.inPins = inPins;
    this.outPins = outPins;
  }

  function Bootstrap(func, send, release) {
    this.func = func;
    this.send = send;
    this.release = release;
  }

  // parentSend - This is the `send()` subroutine to send packets via the sinks
  //   of this composite. We don't have access to this until the parent Composite
  //   calls the main function of this Composite.
  // parentRelease - This is how the Composite triggers the parent Composite to
  //   process any packet sent to this Composite's Sinks.
  const initComposite = (schematic, parentSend, parentRelease) => {
    // Maps Part index in `schematic.parts` to Part object
    const parts = new Array(schematic.parts.length);
    // The main entry points of the Parts, indexed like `parts` above
    const partMains = new Array(schematic.parts.length);
    // Maps wire number to the Parts that are on the receiving end of the wire
    const wireToReceivers = new Array(schematic.wireCount);
    // The input and output queues of the Parts, indexed by the Part index.
    // There is exactly one input queue and one output queue for each Part.
    const inQueue = new Array(schematic.parts.length);
    // The output queue is an array of arrays, first indexed by Part index,
    // then by the Part's pin index.
    const outQueue = new Array(schematic.parts.length);
    // Input pin translation from pin names (strings) to pin indexes (numbers) of
    // the constituent parts.
    const inPins = [];
    // Output pin translation from pin names (strings) to pin indexes (numbers)
    // of the constituent parts.
    const outPins = [];
    // Indexes of the Parts that can be activated
    const readyParts = [];
    const compositeInPins = schematic.self.inPins;
    const compositeOutPins = schematic.self.outPins;
    // We need to transform the `sinks` in schematic, which maps Sink number
    // to Wire number, to an array that maps Wire number to Sink number for
    // efficiency at run-time.
    const wireToSinks = new Array(schematic.wireCount);
    // Maps a tuple of Part ID and output Pin ID to wires
    const partPinToWires = new Array(schematic.parts.length);
    // We need a way to know when to flush the Sinks.
    var flushSinks = false;

    const send = (originatingPartIndex, pinIndex, packet) => {
      outQueue[originatingPartIndex].push(new OutEvent(packet, originatingPartIndex, pinIndex));
    };

    const pushToInQueue = (wireNumber, outEvent) => {
      const receivers = wireToReceivers[wireNumber];
      const sinks = wireToSinks[wireNumber];
      var i, l;
      var receiver;

      // For Sinks
      for (i = 0, l = sinks.length; i < l; i++) {
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

      while (queue.length > 0) {
        outEvent = queue.shift();
        wire = partPinToWires[outEvent.from][outEvent.pin];
        pushToInQueue(wire, outEvent);
      }

      setTimeout(dispatch, 0);
    };

    const runPart = (partIndex, incomingPin, incomingPacket) => {
      var incomingPinName;

      // Translate from pin index to pin name if necessary.
      if (typeof incomingPin === 'number') {
        incomingPinName = inPins[partIndex][incomingPin];
        if (incomingPinName === undefined) {
          throw new Error('Pin index "' + incomingPin + '" not found');
        }
      } else {
        incomingPinName = incomingPin;
      }

      // Run the part's main function.
      partMains[partIndex](incomingPinName, incomingPacket, (outgoingPin, outgoingPacket) => {
        var outgoingPinIndex;

        // Translate pin name to pin index if necessary.
        if (typeof outgoingPin === 'number') {
          outgoingPinIndex = outgoingPin;
        } else {
          outgoingPinIndex = outPins[partIndex].indexOf(outgoingPin);
          if (outgoingPinIndex < 0) {
            throw new Error('Pin name "' + outgoingPin + '" not expected');
          }
        }

        send(partIndex, outgoingPinIndex, outgoingPacket);
      });
    };

    const dispatch = () => {
      var partIndex;
      var queue;
      var inEvent;

      while (readyParts.length > 0) {
        partIndex = readyParts.shift();
        queue = inQueue[partIndex];

        while (queue.length > 0) {
          inEvent = queue.pop();
          runPart(partIndex, inEvent.pin, inEvent.packet);
        }

        release(partIndex);
      }

      if (flushSinks) {
        parentRelease();
      }
    };

    var i, l, m, n, o, p;
    var part;
    var wireNumber;
    var wires;
    var outPinCount;

    // Initialize arrays.
    for (i = 0, l = wireToSinks.length; i < l; i++) {
      wireToSinks[i] = [];
    }
    for (i = 0, l = wireToReceivers.length; i < l; i++) {
      wireToReceivers[i] = [];
    }
    for (i = 0, l = parts.length; i < l; i++) {
      partPinToWires[i] = schematic.parts[i].outPins;
    }

    // Prepare the Sinks.
    for (i = 0, l = compositeOutPins.length; i < l; i++) {
      wireToSinks[compositeOutPins[i]].push(i);
    }

    // Prepare the Parts.
    for (i = 0, l = schematic.parts.length; i < l; i++) {
      part = schematic.parts[i];
      parts[i] = part;
      inQueue[i] = [];
      outQueue[i] = [];

      for (m = 0, n = part.inPins.length; m < n; m++) {
        wireNumber = part.inPins[m];
        wireToReceivers[wireNumber].push(new PartPinTuple(i, m));
      }

      partMains[i] = initPart(allKinds[part.kindName]);
      inPins[i] = allKinds[part.kindName].inPins;
      outPins[i] = allKinds[part.kindName].outPins;
    }

    // The parent of this Composite calls this like a Leaf Part's function with
    // the same arguments to set up the Part. This allows the outer Composites to
    // be able to treat Composites and Leaf Parts in the same way.
    //
    // Whenever there is a packet coming from the outer Composite, push it
    // directly to the queue and wait for dispatch.
    return (sourceNumber, packet, send) => {
      const sourceWireNumber = compositeInPins[sourceNumber];
      if (sourceWireNumber) {
        pushToInQueue(sourceWireNumber, new OutEvent(packet));
      } else {
        // No connection. No action needed.
      }
      setTimeout(dispatch, 0);
    };
  };

  // This takes a leaf definition (see README), extract the input and output pin
  // definitions, and the main and bootstrap routines to be invoked later.
  const initLeaf = (leaf, send, release) => {
    const repoIdOnFilesystem = [leaf.repo, leaf.ref].join('-');
    const repoIdHash = crypto.createHash('sha256').update(repoIdOnFilesystem).digest('hex');
    const repoDir = path.join(leafRootDir, repoIdHash);
    const manifestPath = path.join(repoDir, leaf.dir, leaf.file);
    const manifest = require(manifestPath);
    const entrypointPath = path.join(repoDir, leaf.dir, manifest.entrypoint);

    if (manifest.kindType !== 'nodejs') {
      throw new Error('Kind type must be "nodejs" but is ' + manifest.kindType);
    }

    // Clear Node.js require cache to force each instance of the leaf type to be
    // separate from one another.
    for (var key in require.cache) {
      delete require.cache[key];
    }

    const entrypoint = require(entrypointPath);

    if (typeof entrypoint.main !== 'function') {
      throw new Error('Leaf entrypoint does not export a "main" method.');
    }
    if (!(entrypoint.inPins instanceof Array)) {
      throw new Error('Leaf does not contain an input pin definition.');
    }
    if (!(entrypoint.outPins instanceof Array)) {
      throw new Error('Leaf does not contain an output pin definition.');
    }

    // All instances of the same leaf kind share the same input and output pins
    // anyway so it's ok to replace existing values here.
    allKinds[leaf.kindName].inPins = manifest.inPins;
    allKinds[leaf.kindName].outPins = manifest.outPins;

    // Save bootstrap function to be called at the end of initialization.
    if (entrypoint.bootstrap !== undefined) {
      allLeafPartBootstraps.push(() => entrypoint.bootstrap(send, release));
    }

    return entrypoint.main;
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
          for (j = 0, m = arr.length; j < m; j++) {
            if (typeof arr[i][j] !== 'number') {
              return false;
            }
          }
        }
      }
    }

    return true;
  };

  const isPartDeclaration = (part) => {
    return typeof part.self.kindName === 'string' &&
      typeof part.self.inCount === 'number' &&
      typeof part.self.outCount === 'number' &&
      isArrayOfArrayOfNumbers(part.self.inPins) &&
      isArrayOfArrayOfNumbers(part.self.outPins);
  };

  const isArrayOfParts = (parts) => {
    var i, l;

    if (!(parts instanceof Array)) {
      return false;
    }

    for (i = 0, l = parts.length; i < l; i++) {
      if (!(isPartDeclaration(parts[i]))) {
        return false;
      }
    }

    return true;
  };

  const initPart = (part, send, release) => {
    if (typeof part === 'object') {
      // Leaf part
      const hasContextDir = typeof part.dir === 'string';
      const hasManifestPath = typeof part.file === 'string';
      const hasKindName = typeof part.kindName === 'string';
      const hasGitRef = typeof part.ref === 'string';
      const hasRepoUrl = typeof part.repo === 'string';
      if (hasContextDir && hasManifestPath && hasKindName && hasGitRef && hasRepoUrl) {
        return initLeaf(part, send, release);
      }

      // Composite part
      const hasName = part.hasOwnProperty('name');
      const hasWireCount = part.hasOwnProperty('wireCount') && typeof part.wireCount === 'number';
      const hasSelf = isPartDeclaration(part.hasOwnProperty('self'));
      const hasParts = part.hasOwnProperty('parts') && isArrayOfParts(part.parts);
      if (hasName && hasWireCount && hasSelf && hasParts) {
        return initComposite(part, send, release);
      }
    }

    throw new Error('Unexpected part passed to initialize');
  };

  const allKinds = {};
  const allLeafPartBootstraps = [];
  var leafRootDir;

  // This is the `runKernel` function.
  return (rootDir, kinds, topLevelKindName) => {
    let kind;

    const rootDirStats = fs.statSync(rootDir);
    if (!rootDirStats.isDirectory()) {
      throw new Error('Directory "' + dir + '" does not exist.');
    }
    leafRootDir = rootDir;

    for (var key in kinds) {
      if (typeof kinds[key] !== 'object') {
        throw new Error('Part "' + key + '" must be an object.');
      }

      kind = new Kind;
      kind.definition = kinds[key];
      allKinds[key] = kind;
    }

    initPart(allKinds[topLevelKindName]);

    allLeafPartBootstraps.forEach((bootstrap) => bootstrap());
  };
})();
