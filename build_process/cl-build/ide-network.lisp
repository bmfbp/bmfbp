(hashmap
  "kindName"  "ide"
  "wireCount"  3
  "metaData"  "#({\"dir\"\"build_process/\"\"kindName\"\"svg input\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/svg_input.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"run\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/run.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"build process\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/build_process.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"top-level name\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/top_level_name.json\"\"ref\"\"master\"))"
  "self"  (hashmap
  )
  "parts"  #(
  (hashmap
    "kindName"  "top-level name"
    "partName"  "ID402"
    "inCount"  0
    "outCount"  1
    "inMap"  (hashmap  )
    "outMap"  (hashmap "name"  0 )
    "inPins"  #()
    "outPins"  #(#(0))
  )
  (hashmap
    "kindName"  "build process"
    "partName"  "ID382"
    "inCount"  2
    "outCount"  1
    "inMap"  (hashmap "top-level name"  0 "top-level svg"  1 )
    "outMap"  (hashmap "javascript source code"  0 )
    "inPins"  #(#(0)#(2))
    "outPins"  #(#(1))
  )
  (hashmap
    "kindName"  "run"
    "partName"  "ID394"
    "inCount"  1
    "outCount"  0
    "inMap"  (hashmap "in"  0 )
    "outMap"  (hashmap  )
    "inPins"  #(#(1))
    "outPins"  #()
  )
  (hashmap
    "kindName"  "svg input"
    "partName"  "ID374"
    "inCount"  0
    "outCount"  1
    "inMap"  (hashmap  )
    "outMap"  (hashmap "svg content"  0 )
    "inPins"  #()
    "outPins"  #(#(2))
  )
  )
)