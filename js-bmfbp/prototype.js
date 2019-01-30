// ----------------------------------------------------------------------------
//
// ------------------------
// ----- Requirements -----
// ------------------------
//
// Parts use code from a prototype.  I call that prototype a "kind".  In other languages
// "kind" is called "class" or "prototype".
// Parts are instances of kinds.  A schematic or a system may contain more than one
// instance of the same kind.
//
// The example schematic used must satisfy:
//
// 1. Part(s) that is a "driver" Part that can trigger the flow
// 2. Multiple Parts connected to one downstream Part on one Pin
// 3. Multiple Parts connected to one downstream Part on multiple Pins
// 4. One Part connected to multiple downstream Parts on one Pin
//      a. The first downstream Part modifies the incoming packet. The second
//         downstream Part should not be impacted.
//      b. The downstream Parts share the same wire to honor the
//         "at-the-same-time" semantic. See
//         https://github.com/bmfbp/bmfbp/pull/11#discussion_r252028600.
// 5. One Part connected to multiple downstream Parts on multiple Pins
// 6. Multiple instances of the same Part are used

// ----------------------------------------------------------------------------
//
// ---------------------
// ----- The Kinds -----
// ---------------------

// Kind A: It receives an integer value from input pin 0. It then keeps a count
// incremented by 1 every second. It sends to output pin 0 the new count
// multiplied by that integer value from the input.
function kindA(part, send, releaseDeferred) {
  var count = 0;
  var incrementBy = null;

  setInterval(function () {
    if (incrementBy !== null) {
      count++;
      // TODO: Future suggestion: Allow sending to a pin name instead of a pin
      // index.
      send(part, 0, count * incrementBy);
      releaseDeferred(part);
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

// B: Not used
function kindB() {
}

// Kind C: It receives a count from its IN pin and creates an object with the
// key of "count" and the value as the count from the IN pin. It then sends the
// object to its first OUT pin. If the count is odd, send another packet with a
// message to its second OUT pin.
function kindC(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
      case 1:
        send(part, 0, {
          "count": packet
        });

        if (packet % 2 != 0) {
          send(part, 1, {
            "message": "Odd number detected",
            "count": packet
          });
        }
    }
  };
}

// Kind D: It prints packets from its IN pin to the console.
function kindD(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        console.log("Packet content: " + JSON.stringify(packet));
    }
  };
}

// kind E: It takes the message in the packet from its IN pin, adds one to the
// count property, then print it to the console, prefixed with "ADDED ONE: "
function kindE(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        // TODO: Currently this would increment the count for `partF` as well
        // because there is no copying. This is an issue to be addressed.
        packet.count++;
        console.log("ADDED ONE: " + packet.count);
    }
  };
}

// kind F: It prints the message in the packet from its IN pin to the console,
// prefixed with "WARNING: ".
function kindF(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        console.log("WARNING: " + packet.message + ": " + packet.count);
    }
  };
}

// ----------------------------------------------------------------------------
//
// -------------------------
// ----- The schematic -----
// -------------------------
//
// Conceptually:
//
//     2 --5--> part1 isa A --0--+
//                               |
//     3 --6--> part2 isa A --1--+-> part3 isa C --2--> part4 isa D
//                         |
//                         +-3-+--> part5 isa E
//                             |
//                             +--> part6 isa F
//
// where the IN pin of both part5 and part6 are connected to the same OUT pin of part3.
//
// The numbers in the schematic refer to the wire numbers.

const schematic = {
  // Wires here are same as pipes in grash. Not using the word "pipes" to
  // avoid confusion with UNIX pipes.
  wireCount: 6,
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
      exec: kindA,
      name: "part1"
    },
    {
      inWires: [6],
      outWires: [1],
      inPins: [[6]],
      outPins: [[1]],
      exec: kindA,
      name: "part2"
    },
    {
      inWires: [0, 1],
      outWires: [2, 3],
      // Maps pin index to wire number. e.g. The below says IN pin number 0
      // of this Part is attached to wires number 0 and number 1, which
      // are the same as the wire number above in `inWires`.
      inPins: [[0], [1]],
      // The below says the OUT pin number 0 is attached to wire number 2
      // and the OUT pin number 1 is attached to wire number 3.
      outPins: [[2], [3]],
      exec: kindC,
      name: "part3"
    },
    {
      inWires: [2],
      outWires: [],
      inPins: [[2]],
      outPins: [],
      exec: kindD,
      name: "part4"
    },
    {
      inWires: [3],
      outWires: [],
      inPins: [[3]],
      outPins: [],
      exec: kindE,
      name: "part5"
    },
    {
      inWires: [3],
      outWires: [],
      inPins: [[3]],
      outPins: [],
      exec: kindF,
      name: "part6"
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
//     Packet content: {"count":2}
//     Packet content: {"count":3}
//     ADDED ONE: 4
//     WARNING: Odd number detected: 4
//     Packet content: {"count":4}
//     Packet content: {"count":6}
//     Packet content: {"count":6}
//     Packet content: {"count":9}
//     ADDED ONE: 10
//     WARNING: Odd number detected: 10
//     Packet content: {"count":8}
//     Packet content: {"count":12}
//     Packet content: {"count":10}
//     Packet content: {"count":15}
//     ADDED ONE: 16
//     WARNING: Odd number detected: 16
//     Packet content: {"count":12}
//     Packet content: {"count":18}
//     ...

// --------------------------------------------------
//
// ---------------------------- 
// ----- The bmfbp kernel ----- 
// ---------------------------- 

function bmfbp(schematic) {
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

  function send(originatingPartIndex, pinIndex, packet) {
    outQueue[originatingPartIndex].push(OutEvent(packet, originatingPartIndex, pinIndex));
  }

  function pushToInQueue(wireNumber, outEvent) {
    const receivers = wireToReceivers[wireNumber];
    var i, l;
    var receiver;

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
  }

  var i, l, m, n, o, p;
  var part;
  var wireNumber;
  var constant;

  // Prepare the Parts
  for (i = 0, l = schematic.parts.length; i < l; i++) {
    part = schematic.parts[i];
    parts[i] = part;
    inQueue[i] = [];
    outQueue[i] = [];
    for (m = 0, n = part.inWires.length; m < n; m++) {
      wireNumber = part.inWires[m];
      if (!wireToReceivers || !(wireToReceivers instanceof Array) || !(wireToReceivers[wireNumber] instanceof Array)) {
        wireToReceivers[wireNumber] = [];
      }

      for (o = 0, p = part.inPins.length; o < p; o++) {
        if (part.inPins[o].indexOf(wireNumber) > -1) {
          wireToReceivers[wireNumber].push(new PartPinTuple(i, o));
        }
      }
    }
    partMains[i] = part.exec(i, send, releaseDeferred);
  }

  for (i = 0, l = schematic.constants.length; i < l; i++) {
    constant = schematic.constants[i];
    pushToInQueue(constant.wire, OutEvent(constant.value));
  }

  // This is JavaScript's way to do an infinite loop.
  setInterval(dispatch, 0);
}

bmfbp(schematic);
