{
  "name" : "top_level.js",
  "wirecount" : 11,
  "metadata" : [{"dir":"test_cases/leaves","kindName":"print_to_log","repo":"https://github.com/bmfbp/bmfbp.git","file":"print_to_log.js","ref":"issue-59"},{"dir":"test_cases/leaves","kindName":"output_1_every_second_for_3_times","repo":"https://github.com/bmfbp/bmfbp.git","file":"output_1_every_second_for_3_times.js","ref":"master"},{"dir":"test_cases/leaves","kindName":"add_1","repo":"https://github.com/bmfbp/bmfbp.git","file":"add_1.js","ref":"master"},{"dir":"test_cases/composites","kindName":"tee","repo":"https://github.com/bmfbp/bmfbp.git","file":"tee.svg","ref":"master"},{"dir":"test_cases/composites","kindName":"pass_on_0_add_1_on_1","repo":"https://github.com/bmfbp/bmfbp.git","file":"pass_and_add.svg","ref":"master"},{"dir":"test_cases/leaves","kindName":"duplicate_every_third_input_packet_to_1","repo":"https://github.com/bmfbp/bmfbp.git","file":"duplicate_every_third.js","ref":"master"}],
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
      "partName" : "ID369",
      "in-count" : 0,
      "out-count" : 1,
      "inPins" : [],
      "outPins" : [[2,1,0]],
      "exec" : "output_1_every_second_for_3_times"
    },
    {
      "partName" : "ID372",
      "in-count" : 2,
      "out-count" : 0,
      "inPins" : [[8],[0]],
      "outPins" : [],
      "exec" : "print_to_log"
    },
    {
      "partName" : "ID375",
      "in-count" : 1,
      "out-count" : 1,
      "inPins" : [[1]],
      "outPins" : [[3]],
      "exec" : "add_1"
    },
    {
      "partName" : "ID378",
      "in-count" : 1,
      "out-count" : 2,
      "inPins" : [[2]],
      "outPins" : [[4],[5]],
      "exec" : "tee"
    },
    {
      "partName" : "ID381",
      "in-count" : 2,
      "out-count" : 1,
      "inPins" : [[3],[4]],
      "outPins" : [[7]],
      "exec" : "pass_on_0_add_1_on_1"
    },
    {
      "partName" : "ID384",
      "in-count" : 1,
      "out-count" : 1,
      "inPins" : [[5]],
      "outPins" : [[6]],
      "exec" : "add_1"
    },
    {
      "partName" : "ID387",
      "in-count" : 1,
      "out-count" : 2,
      "inPins" : [[7,6]],
      "outPins" : [[9],[10]],
      "exec" : "duplicate_every_third_input_packet_to_1"
    },
    {
      "partName" : "ID506",
      "in-count" : 1,
      "out-count" : 0,
      "inPins" : [[10]],
      "outPins" : [],
      "exec" : "print_to_log"
    }
  ]
}
