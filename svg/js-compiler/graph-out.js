{
  "name" : "js_test_emitter.js",
  "wirecount" : 3,
  "self" : {
      "partName" : "SELF",
      "in-count" : 0,
      "out-count" : 0,
      "inPins" : [],
      "outPins" : [],
      "exec" : "schematic"
    }
  "parts" : [
    {
      "partName" : "ID392",
      "in-count" : 0,
      "out-count" : 2,
      "inPins" : [],
      "outPins" : [[],[0]],
      "exec" : "assign_wire_numbers_to_inputs"
    },
    {
      "partName" : "ID382",
      "in-count" : 1,
      "out-count" : 2,
      "inPins" : [[0]],
      "outPins" : [[],[1]],
      "exec" : "assign_wire_numbers_to_outputs"
    },
    {
      "partName" : "ID374",
      "in-count" : 1,
      "out-count" : 2,
      "inPins" : [[1]],
      "outPins" : [[],[2]],
      "exec" : "assign_portIndices"
    },
    {
      "partName" : "ID369",
      "in-count" : 1,
      "out-count" : 0,
      "inPins" : [[2]],
      "outPins" : [],
      "exec" : "emit"
    }
  ]
}
