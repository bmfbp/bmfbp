// ----------------------------------------------------------------------------
//
// ----------------------
// ----- The kinds ------
// ----------------------

const kinds = {
  "output_1_every_second_for_3_times": (function () {
    return function (partId, send, release) {
      var count = 0;

      const outputOne = function () {
        send(partId, 0, 1);
        release(partId);

        if (count++ < 3) {
          setTimeout(outputOne, 1000);
        }
      };

      outputOne();

      return function (pin, packet) {};
    };
  })(),
  "add_1": (function () {
    return function (partId, send, release) {
      return function (pin, packet) {
        send(partId, 0, packet + 1);
      };
    };
  })(),
  "duplicate_every_third": (function () {
    return function (partId, send, release) {
      let packetCount = 0;

      return function (pin, packet) {
        if (++packetCount % 3 === 0) {
          send(partId, 1, packet);
        }

        send(partId, 0, packet);
      };
    };
  })(),
  "print_to_log": (function () {
    return function (partId, send, release) {
      return function (pin, packet) {
        console.log(packet);
      };
    };
  })(),
  "pass_and_add": (function () {
    return {
      "name": "pass_and_add",
      "wireCount": 4,
      "self": {
        "partName": "pass_and_add",
        "inCount": 3,
        "outCount": 1,
        "inPins": [[0], [1], [2]],
        "outPins": [[0, 3]],
        "exec": "pass_and_add"
      },
      "parts": [
        {
          "partName": "add_1",
          "inCount": 1,
          "outCount": 1,
          "inPins": [[1]],
          "outPins": [[3]],
          "exec": "add_1"
        }
      ]
    };
  })(),
  "tee": (function () {
    return {
      "name": "tee",
      "wireCount": 3,
      "self": {
        "partName": "tee",
        "inCount": 1,
        "outCount": 3,
        "inPins": [[0, 1]],
        "outPins": [[0], [1], [2]],
        "exec": "tee"
      },
      "parts": [
      ]
    };
  })(),
  "top_level": (function () {
    return {
      "name": "top_level",
      "wireCount": 11,
      "self": {
        "partName": "top_level",
        "inCount": 0,
        "outCount": 0,
        "inPins": [],
        "outPins": [],
        "exec": "top_level"
      },
      "parts": [
        {
          "partName": "output_1_every_second_for_3_times",
          "inCount": 0,
          "outCount": 1,
          "inPins": [],
          "outPins": [[0, 2, 4]],
          "exec": "output_1_every_second_for_3_times"
        },
        {
          "partName": "print_to_log",
          "inCount": 2,
          "outCount": 0,
          "inPins": [[1], [0]],
          "outPins": [],
          "exec": "print_to_log"
        },
        {
          "partName": "add_1",
          "inCount": 1,
          "outCount": 1,
          "inPins": [[2]],
          "outPins": [[3]],
          "exec": "add_1"
        },
        {
          "partName": "tee",
          "inCount": 1,
          "outCount": 2,
          "inPins": [[4]],
          "outPins": [[5], [6]],
          "exec": "tee"
        },
        {
          "partName": "pass_and_add",
          "inCount": 2,
          "outCount": 1,
          "inPins": [[3], [5]],
          "outPins": [[7]],
          "exec": "pass_and_add"
        },
        {
          "partName": "add_1",
          "inCount": 1,
          "outCount": 1,
          "inPins": [[6]],
          "outPins": [[8]],
          "exec": "add_1"
        },
        {
          "partName": "duplicate_every_third",
          "inCount": 1,
          "outCount": 2,
          "inPins": [[7, 8]],
          "outPins": [[9], [10]],
          "exec": "duplicate_every_third"
        },
        {
          "partName": "print_to_log",
          "inCount": 1,
          "outCount": 0,
          "inPins": [[10]],
          "outPins": [],
          "exec": "print_to_log"
        }
      ]
    };
  })()
};


// ----------------------------------------------------------------------------
//
// ---------------------------- 
// ----- The bmfbp kernel ----- 
// ---------------------------- 

function bmfbp(kinds, topLevelName) {
  function PartPinTuple(part, pin) {
    return {
      part: part,
      pin: pin
    };
  }

  function OutEvent(packet, from, pin) {
    return {
      packet: packet,
      from: from,
      pin: pin
    };
  }

  function initComposite(schematic) {
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
    // This is the `send()` subroutine to send packets via the sinks of this
    // composite. We don't have access to this until the parent Composite
    // calls the main function of this Composite.
    var compositeSend = null;
    // We need a way to know when to flush the Sinks.
    var flushSinks = false;
    // This is how the Composite triggers the parent Composite to process any
    // packet sent to this Composite's Sinks.
    var compositeRelease = null;

    function send(originatingPartIndex, pinIndex, packet) {
      outQueue[originatingPartIndex].push(OutEvent(packet, originatingPartIndex, pinIndex));
    }

    function pushToInQueue(wireNumbers, outEvent) {
      var i, l, m, n;
      var wireNumber;
      var receiver;

      for (i = 0, l = wireNumbers.length; i < l; i++) {
        wireNumber = wireNumbers[i];

        // For Sinks
        for (m = 0, n = wireToSinks[wireNumber].length; m < n; m++) {
          compositeSend(wireToSinks[wireNumber][m], outEvent.packet);
          flushSinks = true;
        }

        // For other Parts in the Composite
        for (m = 0, n = wireToReceivers[wireNumber].length; m < n; m++) {
          receiver = wireToReceivers[wireNumber][m];
          readyParts.push(receiver.part);
          inQueue[receiver.part].push({
            pin: receiver.pin,
            packet: outEvent.packet
          });
        }
      }
    }

    function release(partIndex) {
      var i, l;
      var outEvent;
      var wireNumbers;
      const queue = outQueue[partIndex];

      while (queue.length > 0) {
        outEvent = queue.shift();
        wireNumbers = partPinToWires[outEvent.from][outEvent.pin];
        pushToInQueue(wireNumbers, outEvent);
      }

      setTimeout(dispatch, 0);
    }

    function dispatch() {
      var partIndex;
      var queue;
      var inEvent;

      while (readyParts.length > 0) {
        partIndex = readyParts.shift();
        queue = inQueue[partIndex];

        while (queue.length > 0) {
          inEvent = queue.pop();
          partMains[partIndex](inEvent.pin, inEvent.packet);
        }

        release(partIndex);
      }

      if (flushSinks) {
        compositeRelease();
      }
    }

    // The parent of this Composite calls this like a Leaf Part's function with
    // the same arguments to "set up" the Part. This allows the outer
    // Composites to be able to treat Composites and Leaf Parts in the same
    // way.
    function main(partId, send, release) {
      // This is for when a Sink needs to send a packet to the outer
      // Composite. Note that how the Sink would call this `send()`
      // subroutine is a bit different than how a Leaf Part would call its
      // `send()`. The Part number is inferred.
      compositeSend = function (pin, packet) {
        send(partId, pin, packet);
      };

      compositeRelease = function () {
        release(partId);
      };

      setTimeout(dispatch, 0);

      // Whenever there is a packet coming from the outer Composite, push it
      // directly to the queue and wait for dispatch.
      return function (sourceNumber, packet) {
        const sourceWireNumbers = compositeInPins[sourceNumber];
        if (sourceWireNumbers) {
          pushToInQueue(sourceWireNumbers, OutEvent(packet));
        } else {
          // No connection. No action needed.
        }
        setTimeout(dispatch, 0);
      };
    }

    var i, l, m, n, o, p;
    var part;
    var wireNumbers;
    var wires;
    var outPinCount;
    var initialize;

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
      for (m = 0, n = compositeOutPins[i].length; m < n; m++) {
        wireToSinks[compositeOutPins[i][m]].push(i);
      }
    }

    // Prepare the Parts.
    for (i = 0, l = schematic.parts.length; i < l; i++) {
      part = schematic.parts[i];
      parts[i] = part;
      inQueue[i] = [];
      outQueue[i] = [];
      for (m = 0, n = part.inPins.length; m < n; m++) {
        wireNumbers = part.inPins[m];
        for (o = 0, p = wireNumbers.length; o < p; o++) {
          wireToReceivers[wireNumbers[o]].push(new PartPinTuple(i, m));
        }
      }
      initializer = initPart(kinds[part.exec]);
      partMains[i] = initializer(i, send, release);
    }

    return main;
  }

  function initPart(part) {
    // Leaf part
    if (part instanceof Function) {
      return part;
    }

    // Composite
    if (part.hasOwnProperty("wireCount") && part.hasOwnProperty("parts")) {
      return initComposite(part);
    }

    throw new Error("Unexpected Part");
  }

  initPart(kinds[topLevelName])(0);
}


// ----------------------------------------------------------------------------
//
// -----------------------
// ----- Entry point ----- 
// -----------------------

bmfbp(kinds, "top_level");
