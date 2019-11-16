(hashmap
  "kindName"  "build_process"
  "wireCount"  22
  "metaData"  "#({\"dir\"\"build_process/\"\"kindName\"\"get file content in repo\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/get_file_content_in_repo.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"iterator\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/parts/iterator.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"compile composite\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/compile_composite.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"json object stacker\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/json_object_stacker.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"determine kind type\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/determine_kind_type.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"collector\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/collector.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"javascript builder\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/javascript_builder.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"fetch git repo\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/fetch_git_repo.json\"\"ref\"\"master\"){\"dir\"\"build_process/\"\"kindName\"\"prepare temp directory\"\"repo\"\"https//github.com/bmfbp/bmfbp.git\"\"file\"\"parts/prepare_temp_directory.json\"\"ref\"\"master\"))"
  "self"  (hashmap
  )
  "parts"  #(
  (hashmap
    "kindName"  "self"
    "partName"  "ID568"
    "inCount"  0
    "outCount"  1
    "inMap"  (hashmap  )
    "outMap"  (hashmap "top-level name"  0 )
    "inPins"  #()
    "outPins"  #(#(0))
  )
  (hashmap
    "kindName"  "javascript builder"
    "partName"  "ID488"
    "inCount"  3
    "outCount"  1
    "inMap"  (hashmap "top-level name"  0 "temp directory"  1 "intermediate code"  2 )
    "outMap"  (hashmap "javascript source code"  0 )
    "inPins"  #(#(0)#(6)#(16))
    "outPins"  #(#(8))
  )
  (hashmap
    "kindName"  "get file content in repo"
    "partName"  "ID552"
    "inCount"  2
    "outCount"  2
    "inMap"  (hashmap "temp directory"  0 "git repo metadata"  1 )
    "outMap"  (hashmap "metadata"  0 "file content"  1 )
    "inPins"  #(#(3)#(7))
    "outPins"  #(#(1)#(2))
  )
  (hashmap
    "kindName"  "determine kindType"
    "partName"  "ID449"
    "inCount"  2
    "outCount"  2
    "inMap"  (hashmap "part metadata"  0 "file content"  1 )
    "outMap"  (hashmap "leaf metadata"  0 "schematic metadata"  1 )
    "inPins"  #(#(1)#(2))
    "outPins"  #(#(12)#(13))
  )
  (hashmap
    "kindName"  "prepare temp directory"
    "partName"  "ID531"
    "inCount"  0
    "outCount"  1
    "inMap"  (hashmap  )
    "outMap"  (hashmap "directory"  0 )
    "inPins"  #()
    "outPins"  #(#(6543))
  )
  (hashmap
    "kindName"  "get file content in repo"
    "partName"  "ID459"
    "inCount"  2
    "outCount"  1
    "inMap"  (hashmap "temp directory"  0 "git repo metadata"  1 )
    "outMap"  (hashmap "file content"  0 )
    "inPins"  #(#(4)#(13))
    "outPins"  #(#(11))
  )
  (hashmap
    "kindName"  "fetch git repo"
    "partName"  "ID504"
    "inCount"  2
    "outCount"  1
    "inMap"  (hashmap "temp directory"  0 "git repo metadata"  1 )
    "outMap"  (hashmap "metadata"  0 )
    "inPins"  #(#(5)#(19))
    "outPins"  #(#(7))
  )
  (hashmap
    "kindName"  "self"
    "partName"  "ID491"
    "inCount"  1
    "outCount"  0
    "inMap"  (hashmap "javascript source code"  0 )
    "outMap"  (hashmap  )
    "inPins"  #(#(8))
    "outPins"  #()
  )
  (hashmap
    "kindName"  "self"
    "partName"  "ID476"
    "inCount"  0
    "outCount"  1
    "inMap"  (hashmap  )
    "outMap"  (hashmap "top-level svg"  0 )
    "inPins"  #()
    "outPins"  #(#(109))
  )
  (hashmap
    "kindName"  "iterator"
    "partName"  "ID423"
    "inCount"  3
    "outCount"  1
    "inMap"  (hashmap "start"  0 "done"  1 "continue"  2 )
    "outMap"  (hashmap "get a part"  0 )
    "inPins"  #(#(9)#(14)#(20))
    "outPins"  #(#(15))
  )
  (hashmap
    "kindName"  "compile composite"
    "partName"  "ID405"
    "inCount"  1
    "outCount"  2
    "inMap"  (hashmap "svg"  0 )
    "outMap"  (hashmap "graph as json"  0 "parts as json objects"  1 )
    "inPins"  #(#(1110))
    "outPins"  #(#(17)#(18))
  )
  (hashmap
    "kindName"  "collector"
    "partName"  "ID415"
    "inCount"  3
    "outCount"  1
    "inMap"  (hashmap "leaf"  0 "composite"  1 "done"  2 )
    "outMap"  (hashmap "intermediate code"  0 )
    "inPins"  #(#(12)#(17)#(21))
    "outPins"  #(#(16))
  )
  (hashmap
    "kindName"  "json object stacker"
    "partName"  "ID384"
    "inCount"  2
    "outCount"  2
    "inMap"  (hashmap "get a part"  0 "push object"  1 )
    "outMap"  (hashmap "no more"  0 "part metadata"  1 )
    "inPins"  #(#(15)#(18))
    "outPins"  #(#(2114)#(2019))
  )
  )
)
