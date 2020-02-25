(COMPILE_COMPOSITE
  :metadata "\"[{\"dir\":\"build_process/\",\"kindName\":\"split diagram\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/split_diagram.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"compile one diagram\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/compile_one_diagram.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"json array splitter\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/json_array_splitter.json\",\"ref\":\"master\"}]\""
  
   (SVG)
   (GRAPH-AS-JSON PARTS-AS-JSON-OBJECTS)
  
  (:code SPLIT-DIAGRAM (SVG-CONTENT) (METADATA-AS-JSON-ARRAY DIAGRAM))
  (:code COMPILE-ONE-DIAGRAM (DIAGRAM) (GRAPH-AS-JSON))
  (:code JSON-ARRAY-SPLITTER (JSON) (OBJECTS))
  "
    SPLIT-DIAGRAM.DIAGRAM -> COMPILE-ONE-DIAGRAM.DIAGRAM
    SPLIT-DIAGRAM.METADATA-AS-JSON-ARRAY -> JSON-ARRAY-SPLITTER.JSON
    SELF.SVG -> SPLIT-DIAGRAM.SVG-CONTENT
    COMPILE-ONE-DIAGRAM.GRAPH-AS-JSON -> SELF.GRAPH-AS-JSON
    JSON-ARRAY-SPLITTER.OBJECTS -> SELF.PARTS-AS-JSON-OBJECTS
    ")