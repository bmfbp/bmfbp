(hashmap
  "kindName"  "compile_composites"
  "wireCount"  5
  "metaData"  "#({\"dir\"\"build_process/\"\"kindName\"\"split diagram\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/split_diagram.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"compile one diagram\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/compile_one_diagram.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"json array splitter\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/json_array_splitter.json\"\"ref\"\"master\"))"
  "self"  (hashmap
  )
  "parts"  #(
  (hashmap
    "kindName"  "json array splitter"
    "partName"  "ID415"
    "inCount"  1
    "outCount"  1
    "inMap"  (hashmap "json"  0 )
    "outMap"  (hashmap "objects"  0 )
    "inPins"  #(#(3))
    "outPins"  #(#(0))
  )
  (hashmap
    "kindName"  "self"
    "partName"  "ID418"
    "inCount"  1
    "outCount"  0
    "inMap"  (hashmap "parts as json objects"  0 )
    "outMap"  (hashmap  )
    "inPins"  #(#(0))
    "outPins"  #()
  )
  (hashmap
    "kindName"  "compile one diagram"
    "partName"  "ID398"
    "inCount"  1
    "outCount"  1
    "inMap"  (hashmap "diagram"  0 )
    "outMap"  (hashmap "graph as json"  0 )
    "inPins"  #(#(4))
    "outPins"  #(#(1))
  )
  (hashmap
    "kindName"  "self"
    "partName"  "ID423"
    "inCount"  1
    "outCount"  0
    "inMap"  (hashmap "graph as json"  0 )
    "outMap"  (hashmap  )
    "inPins"  #(#(1))
    "outPins"  #()
  )
  (hashmap
    "kindName"  "self"
    "partName"  "ID403"
    "inCount"  0
    "outCount"  1
    "inMap"  (hashmap  )
    "outMap"  (hashmap "svg"  0 )
    "inPins"  #()
    "outPins"  #(#(2))
  )
  (hashmap
    "kindName"  "split diagram"
    "partName"  "ID379"
    "inCount"  1
    "outCount"  2
    "inMap"  (hashmap "svg content"  0 )
    "outMap"  (hashmap "metadata as json array"  0 "diagram"  1 )
    "inPins"  #(#(2))
    "outPins"  #(#(3)#(4))
  )
  )
)
