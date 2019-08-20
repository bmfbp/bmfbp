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
      "partName" : "ID505",
      "inCount" : 0,
      "outCount" : 0,
      "inPins" : [],
      "outPins" : [],
      "kindName" : "print_to_log"
    },
    {
      "partName" : "ID387",
      "inCount" : 0,
      "outCount" : 1,
      "inPins" : [],
      "outPins" : [[1]],
      "kindName" : "duplicate_every_third_input_packet_to_1"
    },
    {
      "partName" : "ID384",
      "inCount" : 0,
      "outCount" : 0,
      "inPins" : [],
      "outPins" : [],
      "kindName" : "add_1"
    },
    {
      "partName" : "ID381",
      "inCount" : 1,
      "outCount" : 0,
      "inPins" : [[7]],
      "outPins" : [],
      "kindName" : "pass_on_0_add_1_on_1"
    },
    {
      "partName" : "ID378",
      "inCount" : 0,
      "outCount" : 1,
      "inPins" : [],
      "outPins" : [[6]],
      "kindName" : "tee"
    },
    {
      "partName" : "ID375",
      "inCount" : 0,
      "outCount" : 0,
      "inPins" : [],
      "outPins" : [],
      "kindName" : "add_1"
    },
    {
      "partName" : "ID372",
      "inCount" : 1,
      "outCount" : 0,
      "inPins" : [[2]],
      "outPins" : [],
      "kindName" : "print_to_log"
    },
    {
      "partName" : "ID369",
      "inCount" : 0,
      "outCount" : 0,
      "inPins" : [],
      "outPins" : [],
      "kindName" : "output_1_every_second_for_3_times"
    }
  ]
}
