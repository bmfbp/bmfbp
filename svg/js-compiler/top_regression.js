{
  "name" : "top_level.js",
  "wirecount" : 11,
  "metadata" : [{"dir":"test_cases/leaves","kindName":"print_to_log","repo":"https://github.com/bmfbp/bmfbp.git","file":"print_to_log.js","ref":"issue-59"},{"dir":"test_cases/leaves","kindName":"output_1_every_second_for_3_times","repo":"https://github.com/bmfbp/bmfbp.git","file":"output_1_every_second_for_3_times.js","ref":"master"},{"dir":"test_cases/leaves","kindName":"add_1","repo":"https://github.com/bmfbp/bmfbp.git","file":"add_1.js","ref":"master"},{"dir":"test_cases/composites","kindName":"tee","repo":"https://github.com/bmfbp/bmfbp.git","file":"tee.svg","ref":"master"},{"dir":"test_cases/composites","kindName":"pass_on_0_add_1_on_1","repo":"https://github.com/bmfbp/bmfbp.git","file":"pass_and_add.svg","ref":"master"},{"dir":"test_cases/leaves","kindName":"duplicate_every_third_input_packet_to_1","repo":"https://github.com/bmfbp/bmfbp.git","file":"duplicate_every_third.js","ref":"master"}],
  "self" : {
      "partName" : "SELF",
      "inCount" : 0,
      "outCount" : 0,
      "inPins" : [],
      "outPins" : [],
      "kindName" : "schematic"
    }
  "parts" : [
    {
      "partName" : "ID369",
      "inCount" : 0,
      "outCount" : 1,
      "inPins" : [],
      "outPins" : [[2,1,0]],
      "kindName" : "output_1_every_second_for_3_times"
    },
    {
      "partName" : "ID372",
      "inCount" : 2,
      "outCount" : 0,
      "inPins" : [[8],[0]],
      "outPins" : [],
      "kindName" : "print_to_log"
    },
    {
      "partName" : "ID375",
      "inCount" : 1,
      "outCount" : 1,
      "inPins" : [[1]],
      "outPins" : [[3]],
      "kindName" : "add_1"
    },
    {
      "partName" : "ID378",
      "inCount" : 1,
      "outCount" : 2,
      "inPins" : [[2]],
      "outPins" : [[4],[5]],
      "kindName" : "tee"
    },
    {
      "partName" : "ID381",
      "inCount" : 2,
      "outCount" : 1,
      "inPins" : [[3],[4]],
      "outPins" : [[7]],
      "kindName" : "pass_on_0_add_1_on_1"
    },
    {
      "partName" : "ID384",
      "inCount" : 1,
      "outCount" : 1,
      "inPins" : [[5]],
      "outPins" : [[6]],
      "kindName" : "add_1"
    },
    {
      "partName" : "ID387",
      "inCount" : 1,
      "outCount" : 2,
      "inPins" : [[7,6]],
      "outPins" : [[9],[10]],
      "kindName" : "duplicate_every_third_input_packet_to_1"
    },
    {
      "partName" : "ID505",
      "inCount" : 1,
      "outCount" : 0,
      "inPins" : [[10]],
      "outPins" : [],
      "kindName" : "print_to_log"
    }
  ]
}
