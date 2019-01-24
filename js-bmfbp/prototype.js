// ----------------------------------------------------------------------------
//
// The Parts

// Part A: It keeps an incrementing count starting from 0 every second,
// multiplied by 2 and send it to its OUT pin.
function partA(part, send, releaseDeferred) {
  var count = 0;

  setInterval(function () {
    count++;
    // TODO: Future suggestion: Allow sending to a pin name instead of a pin
    // index.
    send(part, 0, count * 2);
    releaseDeferred(part);
  }, 1000);

  // This two-layer definition is necessary because everything in JS is wrapped
  // in a lambda and we don't have access to mutable variables that survive
  // across function calls.
  return function (pin, packet) {
  };
}

// Part B: It keeps an incrementing count starting from 0 every second,
// multiplied by 3 and send it to its OUT pin.
function partB(part, send, releaseDeferred) {
  var count = 0;

  setInterval(function () {
    count++;
    send(part, 0, count * 3);
    releaseDeferred(part);
  }, 1000);

  return function (pin, packet) {
  };
}

// Part C: It receives a count from its IN pin and creates an object with the
// key of "count" and the value as the count from the IN pin. It then sends the
// object to its first OUT pin. If the count is odd, send another packet with a
// message to its second OUT pin.
function partC(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
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

// Part D: It prints packets from its IN pin to the console.
function partD(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        console.log(packet);
    }
  };
}

// Part E: It takes the message in the packet from its IN pin, adds one to the
// count property, then print it to the console, prefixed with "ADDED ONE: "
function partE(part, send) {
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

// Part F: It prints the message in the packet from its IN pin to the console,
// prefixed with "WARNING: ".
function partF(part, send) {
  return function (pin, packet) {
    switch (pin) {
      case 0:
        console.log("WARNING: " + packet.message + ": " + packet.count);
    }
  };
}

// ----------------------------------------------------------------------------
//
// The schematic, conceptually:
//
//     B --0--+
//            |
//            v
//     A --1--+-> C --2---> D
//                |
//                +-+--3--> E
//                  +--4--> F
//
// where the IN pin of both E and F are connected to the same OUT pin of C.
//
// The numbers in the schematic refer to the wire numbers.

const schematic = {
  // Wires here are same as pipes in grash. Not using the word "pipes" to
  // avoid confusion with UNIX pipes.
  wireCount: 5,
  parts: [
    {
      // TODO: Discussion item: Do we even need to keep track of which wires
      // are incoming and outgoing? They are already indirectly tracked with
      // which pins they belong to.
      inWires: [],
      // The pin index in `send()` is the index of this array, meaning that
      // if the following is `[3, 4]`, the Part would call `send()` with
      // `send(1, "whatever")` to send the message down wire number 4.
      outWires: [0],
      inPins: [],
      outPins: [[0]],
      exec: partA
    },
    {
      inWires: [],
      outWires: [1],
      inPins: [],
      outPins: [[1]],
      exec: partB
    },
    {
      inWires: [0, 1],
      outWires: [2, 3, 4],
      // Maps pin index to wire number. e.g. The below says IN pin number 0
      // of this Part is attached to wires number 0 and number 1, which
      // are the same as the wire number above in `inWires`.
      inPins: [[0, 1]],
      // The below says the OUT pin number 0 is attached to wire number 2
      // and the OUT pin number 1 is attached to wire number 3.
      outPins: [[2], [3, 4]],
      exec: partC
    },
    {
      inWires: [2],
      outWires: [],
      inPins: [[2]],
      outPins: [],
      exec: partD
    },
    {
      inWires: [3],
      outWires: [],
      inPins: [[3]],
      outPins: [],
      exec: partE
    },
    {
      inWires: [4],
      outWires: [],
      inPins: [[4]],
      outPins: [],
      exec: partF
    }
  ]
};

// --------------------------------------------------
//
// The bmfbp runtime

function bmfbp(schematic) {
  // Maps Part index in `schematic.parts` to Part object
  const parts = new Array(schematic.parts.length);
  // The main entry points of the Parts, indexed like `parts` above
  const partMains = new Array(schematic.parts.length);
  // Maps wire number to the Part that is on the receiving end of the wire
  const wireToReceiver = new Array(schematic.wireCount);
  // Maps input wire number to the pin index of the receiving Part
  const wireToReceiverPin = new Array(schematic.parts.length);
  // The input and output queues of the Parts, indexed by the Part index.
  // There is exactly one input queue and one output queue for each Part.
  const inQueue = new Array(schematic.parts.length);
  // The output queue is an array of arrays, first indexed by Part index,
  // then by the Part's pin index.
  const outQueue = new Array(schematic.parts.length);
  // Indexes of the Parts that can be activated
  const readyParts = [];

  function send(originatingPartIndex, pinIndex, packet) {
    outQueue[originatingPartIndex].push({
      from: originatingPartIndex,
      pin: pinIndex,
      packet: packet
    });
  }

  function releaseDeferred(partIndex) {
    var i, l;
    var receivingPartIndex;
    var outEvent;
    var wireNumber;

    const queue = outQueue[partIndex];
    while (queue.length > 0) {
      outEvent = queue.pop();

      const wires = parts[outEvent.from].outPins[outEvent.pin];
      for (i = 0, l = wires.length; i < l; i++) {
        wireNumber = wires[i];
        receivingPartIndex = wireToReceiver[wireNumber];
        inQueue[receivingPartIndex].push({
          pin: wireToReceiverPin[receivingPartIndex][wireNumber],
          packet: outEvent.packet
        });
        readyParts.push(receivingPartIndex);
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

  // Prepare the Parts
  for (i = 0, l = schematic.parts.length; i < l; i++) {
    part = schematic.parts[i];
    parts[i] = part;
    wireToReceiverPin[i] = new Array(schematic.wireCount);
    inQueue[i] = [];
    outQueue[i] = [];
    for (m = 0, n = part.inWires.length; m < n; m++) {
      wireNumber = part.inWires[m];
      wireToReceiver[wireNumber] = i;

      for (o = 0, p = part.inPins.length; o < p; o++) {
        if (part.inPins[o].indexOf(wireNumber) > -1) {
          wireToReceiverPin[i][wireNumber] = o;
        }
      }
    }
    partMains[i] = part.exec(i, send, releaseDeferred);
  }

  // This is JavaScript's way to do an infinite loop.
  setInterval(dispatch, 0);
}

bmfbp(schematic);
