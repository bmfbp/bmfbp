// ----------------------------------------------------------------------------
//
// ------------------------
// ----- Requirements -----
// ------------------------
//
// The example schematic used must satisfy:
//
// 1.  Part(s) that is a "driver" Part that can trigger the flow
// 2.  Multiple Parts connected to one downstream Part on one Pin
// 3.  Multiple Parts connected to one downstream Part on multiple Pins
// 4.  One Part connected to multiple downstream Parts on one Pin
//       a. The first downstream Part modifies the incoming packet. The
//          second downstream Part should not be impacted.
//       b. The downstream Parts share the same wire to honor the
//          "at-the-same-time" semantic. See
//          https://github.com/bmfbp/bmfbp/pull/11#discussion_r252028600.
// 5.  One Part connected to multiple downstream Parts on multiple Pins
// 6.  Multiple instances of the same Kind are used within one Composite
// 7.  Use Composites
// 8.  Multiple instances of the same Kind are used in multiple composites
// 9.  A source of a Composite is connected directly to a sink of that same
//     Composite.
// 10. A Sink of a Composite that is not connected
// 11. A Source of a Composite that is not connected
// 12. An output pin of a Leaf Part that is not connected

// ----------------------------------------------------------------------------
//
// ---------------------
// ----- The Kinds -----
// ---------------------

// Kind A: It receives an integer value from input pin 0. It then keeps a count
// incremented by 1 every second. It sends to output pin 0 the new count
// multiplied by that integer value from the input.
function kindA(partId, send, releaseDeferred) {
  var count = 0;
  var incrementBy = null;

  setInterval(function () {
    if (incrementBy !== null) {
      count++;
      // TODO: Future suggestion: Allow sending to a pin name instead of a pin
      // index.
      send(partId, 0, count * incrementBy);
      releaseDeferred(partId);
    }
  }, 1000);

  // This two-layer definition is necessary because everything in JS is wrapped
  // in a lambda and we don't have access to mutable variables that survive
  // across function calls.
  return function (pin, packet) {
    switch (pin) {
      case 0:
        incrementBy = packet;
    }
  };
}

// Kind B: It receives a packet from input pin 0. It then prefix that packet to
// all incoming packets from input pin 1 and outputs to output pin 0.
function kindB(partId, send) {
  var prefix = "";

  return function (pin, packet) {
    switch (pin) {
      case 0:
        prefix = packet;
        break;
      case 1:
        send(partId, 0, prefix + JSON.stringify(packet));
        break;
    }
  };
}

// Kind C: It receives a count from its IN pin and creates an object with the
// key of "count" and the value as the count from the IN pin. It then sends the
// object to its first OUT pin. If the count is odd, send another packet with a
// message to its second OUT pin.
function kindC(partId, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        send(partId, 0, {
          "count": packet
        });

        if (packet % 2 != 0) {
          send(partId, 1, {
            "message": "Odd number detected",
            "count": packet
          });
        }
    }
  };
}

// Kind D: It prints packets from its IN pin to the console.
function kindD(partId, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        console.log("Packet content: " + JSON.stringify(packet));
    }
  };
}

// Kind E: It takes the message in the packet from its IN pin, adds one to the
// count property, then print it to the console, prefixed with "ADDED ONE: "
function kindE(partId, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        packet.count++;
        console.log("ADDED ONE: " + packet.count);
    }
  };
}

// Kind F: It prints the message in the packet from its IN pin to the console,
// prefixed with "WARNING: " and send it to output pin 0.
function kindF(partId, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        const message = "WARNING: " + packet.message + ": " + packet.count;
        console.log(message);
    }
  };
}

// Kind G: This is the COPY Kind with two output pins. The incoming packet must
// not contain circular reference.
function kindG(partId, send) {
  function copy(packet) {
    return JSON.parse(JSON.stringify(packet));
  }

  return function (pin, packet) {
    switch (pin) {
      case 0:
        send(partId, 0, copy(packet));
        send(partId, 1, copy(packet));
    }
  };
}

// ----------------------------------------------------------------------------
//
// -------------------------
// ----- The schematic -----
// -------------------------
//
// See the `drawings` directory.

const compositeN = {
  name: "compositeN",
  // Wires here are same as pipes in grash. Not using the word "pipes" to
  // avoid confusion with UNIX pipes.
  wireCount: 9,
  // These are constants sent to the specified wires once the network has been
  // loaded.
  constants: [
    {
      value: 2,
      wire: 5
    },
    {
      value: 3,
      wire: 6
    },
  ],
  sources: [],
  sinks: [2],
  parts: [
    {
      // TODO: Discussion item: Do we even need to keep track of which wires
      // are incoming and outgoing? They are already indirectly tracked with
      // which pins they belong to.
      inWires: [5],
      // The pin index in `send()` is the index of this array, meaning that
      // if the following is `[3, 4]`, the Part would call `send()` with
      // `send(1, "whatever")` to send the message down wire number 4.
      outWires: [0],
      inPins: [[5]],
      outPins: [[0]],
      exec: kindA
    },
    {
      inWires: [6],
      outWires: [0],
      inPins: [[6]],
      outPins: [[0]],
      exec: kindA
    },
    {
      inWires: [0],
      outWires: [2, 3],
      // Maps pin index to wire number. e.g. The below says IN pin number 0
      // of this Part is attached to wires number 0 and number 1, which
      // are the same as the wire number above in `inWires`.
      inPins: [[0]],
      // The below says the OUT pin number 0 is attached to wire number 2
      // and the OUT pin number 1 is attached to wire number 3.
      outPins: [[2], [3]],
      exec: kindC
    },
    {
      inWires: [2],
      outWires: [],
      inPins: [[2]],
      outPins: [],
      exec: kindD
    },
    {
      inWires: [7],
      outWires: [],
      inPins: [[7]],
      outPins: [],
      exec: kindE
    },
    {
      inWires: [8],
      outWires: [],
      inPins: [[8]],
      outPins: [],
      exec: kindF
    },
    {
      inWires: [3],
      outWires: [7, 8],
      inPins: [[3]],
      outPins: [[7], [8]],
      exec: kindG
    }
  ]
};

const compositeO = {
  name: "compositeO",
  wireCount: 4,
  constants: [
    {
      value: "Composite O: ",
      wire: 0
    }
  ],
  // Maps the source number to wire number
  sources: [1, 3],
  // Maps the sink number to wire number
  sinks: [3],
  parts: [
    {
      inWires: [0, 1],
      outWires: [2],
      inPins: [[0], [1]],
      outPins: [[2]],
      exec: kindB
    },
    {
      inWires: [2],
      outWires: [],
      inPins: [[2]],
      outPins: [],
      exec: kindD
    }
  ]
};

const compositeP = {
  name: "compositeP",
  wireCount: 3,
  constants: [
    {
      value: "Test NC 1",
      wire: 1
    }
  ],
  sources: [],
  sinks: [],
  parts: [
    {
      inWires: [],
      outWires: [0],
      inPins: [],
      outPins: [[0]],
      exec: compositeN
    },
    {
      inWires: [0, 1, 2],
      outWires: [],
      inPins: [[0], [1], [2]],
      outPins: [[]],
      exec: compositeO
    }
  ]
};

// --------------------------------------------------
//
// ------------------------- 
// ----- Sample output ----- 
// ------------------------- 
//
// Note that this network runs indefinitely.
//
// The first column is the Composite name, the second column is the Kind
// name, and the third column is the console output.
//
//     N D    Packet content: {"count":2}
//     N D    Packet content: {"count":3}
//     N E    ADDED ONE: 4
//     N F    WARNING: Odd number detected: 3
//     O D    Packet content: "Composite O: {\"count\":2}"
//     O D    Packet content: "Composite O: {\"count\":3}"
//     N D    Packet content: {"count":4}
//     N D    Packet content: {"count":6}
//     O D    Packet content: "Composite O: {\"count\":4}"
//     O D    Packet content: "Composite O: {\"count\":6}"
//     N D    Packet content: {"count":6}
//     N D    Packet content: {"count":9}
//     N E    ADDED ONE: 10
//     N F    WARNING: Odd number detected: 9
//     O D    Packet content: "Composite O: {\"count\":6}"
//     O D    Packet content: "Composite O: {\"count\":9}"
//     N D    Packet content: {"count":8}
//     N D    Packet content: {"count":12}
//     O D    Packet content: "Composite O: {\"count\":8}"
//     O D    Packet content: "Composite O: {\"count\":12}"
//            ...

// --------------------------------------------------
//
// ---------------------------- 
// ----- The bmfbp kernel ----- 
// ---------------------------- 

function bmfbp(topComposite) {
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
    const wireToSource = schematic.sources;
    // We need to transform the `sinks` in schematic, which maps Sink number
    // to Wire number, to an array that maps Wire number to Sink number for
    // efficiency at run-time.
    const wireToSinks = new Array(schematic.wireCount);
    // This is the `send()` subroutine to send packets via the sinks of this
    // composite. We don't have access to this until the parent Composite
    // calls the main function of this Composite.
    var compositeSend = null;
    // We need a way to know when to flush the Sinks.
    var flushSinks = false;
    // This is how the Composite triggers the parent Composite to process any
    // packet sent to this Composite's Sinks.
    var releaseCompositeDeferred = null;

    function send(originatingPartIndex, pinIndex, packet) {
      outQueue[originatingPartIndex].push(OutEvent(packet, originatingPartIndex, pinIndex));
    }

    function pushToInQueue(wireNumber, outEvent) {
      const receivers = wireToReceivers[wireNumber];
      const sinks = wireToSinks[wireNumber];
      var i, l;
      var receiver;

      // For Sinks
      for (i = 0, l = sinks.length; i < l; i++) {
        compositeSend(sinks[i], outEvent.packet);
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
    }

    function releaseDeferred(partIndex) {
      var i, l;
      var outEvent;

      const queue = outQueue[partIndex];
      while (queue.length > 0) {
        outEvent = queue.shift();

        const wires = parts[outEvent.from].outPins[outEvent.pin];
        for (i = 0, l = wires.length; i < l; i++) {
          pushToInQueue(wires[i], outEvent);
        }
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

        releaseDeferred(partIndex);
      }

      if (flushSinks) {
        releaseCompositeDeferred();
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

      releaseCompositeDeferred = function () {
        release(partId);
      };

      setTimeout(dispatch, 0);

      // Whenever there is a packet coming from the outer Composite, push it
      // directly to the queue and wait for dispatch.
      return function (sourceNumber, packet) {
        pushToInQueue(wireToSource[sourceNumber], OutEvent(packet));
        setTimeout(dispatch, 0);
      };
    }

    var i, l, m, n, o, p;
    var part;
    var wireNumber;
    var constant;

    // Initialize arrays.
    for (i = 0, l = wireToSinks.length; i < l; i++) {
      wireToSinks[i] = [];
    }
    for (i = 0, l = wireToReceivers.length; i < l; i++) {
      wireToReceivers[i] = [];
    }

    // Prepare the Sinks.
    for (i = 0, l = schematic.sinks.length; i < l; i++) {
      wireToSinks[schematic.sinks[i]].push(i);
    }

    // Prepare the Parts.
    for (i = 0, l = schematic.parts.length; i < l; i++) {
      part = schematic.parts[i];
      parts[i] = part;
      inQueue[i] = [];
      outQueue[i] = [];
      for (m = 0, n = part.inWires.length; m < n; m++) {
        wireNumber = part.inWires[m];
        for (o = 0, p = part.inPins.length; o < p; o++) {
          if (part.inPins[o].indexOf(wireNumber) > -1) {
            wireToReceivers[wireNumber].push(new PartPinTuple(i, o));
          }
        }
      }
      partMains[i] = initPart(part.exec)(i, send, releaseDeferred);
    }

    for (i = 0, l = schematic.constants.length; i < l; i++) {
      constant = schematic.constants[i];
      pushToInQueue(constant.wire, OutEvent(constant.value));
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

  initPart(topComposite);
}

// --------------------------------------------------
//
// -----------------------
// ----- Entry point ----- 
// -----------------------

// Normally we just need to initiate one bmfbp system. To run multiple bmfbp
// systems, call `bmfbp()` multiple times. See
// https://github.com/bmfbp/bmfbp/issues/12#issuecomment-458563466 for possible
// reasons why we would want to do that.
bmfbp(compositeP);
