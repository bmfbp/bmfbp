{
  "partName" : "top_level",
  "wireCount" : 11,
  "metaData" : "[{\"dir\":\"test_cases/leaves\",\"kindName\":\"print_to_log\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"print_to_log.js\",\"ref\":\"issue-59\"},{\"dir\":\"test_cases/leaves\",\"kindName\":\"output_1_every_second_for_3_times\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"output_1_every_second_for_3_times.js\",\"ref\":\"master\"},{\"dir\":\"test_cases/leaves\",\"kindName\":\"add_1\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"add_1.js\",\"ref\":\"master\"},{\"dir\":\"test_cases/composites\",\"kindName\":\"tee\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"tee.svg\",\"ref\":\"master\"},{\"dir\":\"test_cases/composites\",\"kindName\":\"pass_on_0_add_1_on_1\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"pass_and_add.svg\",\"ref\":\"master\"},{\"dir\":\"test_cases/leaves\",\"kindName\":\"duplicate_every_third_input_packet_to_1\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"duplicate_every_third.js\",\"ref\":\"master\"}]",
  "self" : {
    "kindName" : "self",
    "partName" : "self",
    "inCount" : 1,
    "outCount" : 1,
    "inMap" : { NULL : 0 },
    "outMap" : { NULL : 0 },
    "inPins" : [[2]],
    "outPins" : [[1]]
  },
  "parts" : [
  {
    "kindName" : "duplicate_every_third_input_packet_to_1",
    "partName" : ID387,
    "inCount" : 1,
    "outCount" : 2,
    "inMap" : { 0 : 0 },
    "outMap" : { 1 : 0, 0 : 1 },
    "inPins" : [[4,3]],
    "outPins" : [[0],[1]]
  },
  {
    "kindName" : "print_to_log",
    "partName" : ID505,
    "inCount" : 1,
    "outCount" : 0,
    "inMap" : { 0 : 0 },
    "outMap" : {  },
    "inPins" : [[0]],
    "outPins" : []
  },
  {
    "kindName" : "print_to_log",
    "partName" : ID372,
    "inCount" : 2,
    "outCount" : 0,
    "inMap" : { 0 : 0, 1 : 1 },
    "outMap" : {  },
    "inPins" : [[2],[10]],
    "outPins" : []
  },
  {
    "kindName" : "pass_on_0_add_1_on_1",
    "partName" : ID381,
    "inCount" : 2,
    "outCount" : 1,
    "inMap" : { 1 : 0, 0 : 1 },
    "outMap" : { 0 : 0 },
    "inPins" : [[6],[7]],
    "outPins" : [[3]]
  },
  {
    "kindName" : "add_1",
    "partName" : ID384,
    "inCount" : 1,
    "outCount" : 1,
    "inMap" : { 0 : 0 },
    "outMap" : { 0 : 0 },
    "inPins" : [[5]],
    "outPins" : [[4]]
  },
  {
    "kindName" : "tee",
    "partName" : ID378,
    "inCount" : 1,
    "outCount" : 2,
    "inMap" : { 0 : 0 },
    "outMap" : { 1 : 0, 0 : 1 },
    "inPins" : [[8]],
    "outPins" : [[5],[6]]
  },
  {
    "kindName" : "add_1",
    "partName" : ID375,
    "inCount" : 1,
    "outCount" : 1,
    "inMap" : { 0 : 0 },
    "outMap" : { 0 : 0 },
    "inPins" : [[9]],
    "outPins" : [[7]]
  },
  {
    "kindName" : "output_1_every_second_for_3_times",
    "partName" : ID369,
    "inCount" : 0,
    "outCount" : 1,
    "inMap" : {  },
    "outMap" : { 0 : 0 },
    "inPins" : [],
    "outPins" : [[10,9,8]]
  }
  ]
}
