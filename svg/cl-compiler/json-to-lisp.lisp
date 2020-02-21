(defun jtest ()
  ;;(let ((str (alexandria:read-file-into-string "~/quicklisp/local-projects/bmfbp/svg/cl-compiler/junk.json")))
    (let ((str

"{
  \"name\" : \"self\",
  
  \"metadata\" : \"\\\"[{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"get file content in repo\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/get_file_content_in_repo.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"iterator\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/parts/iterator.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"compile composite\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/compile_composite.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"json object stacker\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/json_object_stacker.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"determine kind type\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/determine_kind_type.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"collector\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/collector.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"javascript builder\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/javascript_builder.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"fetch git repo\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/fetch_git_repo.json\\\",\\\"ref\\\":\\\"master\\\"},{\\\"dir\\\":\\\"build_process/\\\",\\\"kindName\\\":\\\"prepare temp directory\\\",\\\"repo\\\":\\\"https://github.com/bmfbp/bmfbp.git\\\",\\\"file\\\":\\\"parts/prepare_temp_directory.json\\\",\\\"ref\\\":\\\"master\\\"}]\\\"\",
  
  \"inputs\" : [],
  \"outputs\" : [],
  \"parts\" :
  [
    { \"partName\" : \"FETCH-GIT-REPO\", \"kindName\" : \"FETCH-GIT-REPO\"},
    { \"partName\" : \"COMPILE-COMPOSITE\", \"kindName\" : \"COMPILE-COMPOSITE\"},
    { \"partName\" : \"GET-FILE-CONTENT-IN-REPO\", \"kindName\" : \"GET-FILE-CONTENT-IN-REPO\"},
    { \"partName\" : \"COLLECTOR\", \"kindName\" : \"COLLECTOR\"},
    { \"partName\" : \"PREPARE-TEMP-DIRECTORY\", \"kindName\" : \"PREPARE-TEMP-DIRECTORY\"},
    { \"partName\" : \"JAVASCRIPT-BUILDER\", \"kindName\" : \"JAVASCRIPT-BUILDER\"},
    { \"partName\" : \"ITERATOR\", \"kindName\" : \"ITERATOR\"},
    { \"partName\" : \"GET-FILE-CONTENT-IN-REPO\", \"kindName\" : \"GET-FILE-CONTENT-IN-REPO\"},
    { \"partName\" : \"DETERMINE-KINDTYPE\", \"kindName\" : \"DETERMINE-KINDTYPE\"},
    { \"partName\" : \"JSON-OBJECT-STACKER\", \"kindName\" : \"JSON-OBJECT-STACKER\"}
  ],
  \"wiring\" :
    [
      {\"wire-index\" : 0, \"sources\" : [{\"part\" : \"SELF\", \"pin\" : \"TOP-LEVEL-NAME\"}], \"receivers\" : [{\"part\" : \"JAVASCRIPT-BUILDER\", \"pin\" : \"TOP-LEVEL-NAME\"}]},
      {\"wire-index\" : 1, \"sources\" : [{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"METADATA\"}], \"receivers\" : [{\"part\" : \"DETERMINE-KINDTYPE\", \"pin\" : \"PART-METADATA\"}]},
      {\"wire-index\" : 2, \"sources\" : [{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"FILE-CONTENT\"}], \"receivers\" : [{\"part\" : \"DETERMINE-KINDTYPE\", \"pin\" : \"FILE-CONTENT\"}]},
      {\"wire-index\" : 3, \"sources\" : [{\"part\" : \"PREPARE-TEMP-DIRECTORY\", \"pin\" : \"DIRECTORY\"}], \"receivers\" : [{\"part\" : \"JAVASCRIPT-BUILDER\", \"pin\" : \"TEMP-DIRECTORY\"},{\"part\" : \"FETCH-GIT-REPO\", \"pin\" : \"TEMP-DIRECTORY\"},{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"TEMP-DIRECTORY\"},{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"TEMP-DIRECTORY\"}]},
      {\"wire-index\" : 4, \"sources\" : [{\"part\" : \"FETCH-GIT-REPO\", \"pin\" : \"METADATA\"}], \"receivers\" : [{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"GIT-REPO-METADATA\"}]},
      {\"wire-index\" : 5, \"sources\" : [{\"part\" : \"JAVASCRIPT-BUILDER\", \"pin\" : \"TOP-LEVEL-NAME\"}], \"receivers\" : [{\"part\" : \"SELF\", \"pin\" : \"JAVASCRIPT-SOURCE-CODE\"}]},
      {\"wire-index\" : 6, \"sources\" : [{\"part\" : \"SELF\", \"pin\" : \"TOP-LEVEL-SVG\"}], \"receivers\" : [{\"part\" : \"COMPILE-COMPOSITE\", \"pin\" : \"SVG\"},{\"part\" : \"ITERATOR\", \"pin\" : \"START\"}]},
      {\"wire-index\" : 7, \"sources\" : [{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"FILE-CONTENT\"}], \"receivers\" : [{\"part\" : \"COMPILE-COMPOSITE\", \"pin\" : \"SVG\"}]},
      {\"wire-index\" : 8, \"sources\" : [{\"part\" : \"DETERMINE-KINDTYPE\", \"pin\" : \"LEAF-METADATA\"}], \"receivers\" : [{\"part\" : \"COLLECTOR\", \"pin\" : \"LEAF\"}]},
      {\"wire-index\" : 9, \"sources\" : [{\"part\" : \"DETERMINE-KINDTYPE\", \"pin\" : \"PART-METADATA\"}], \"receivers\" : [{\"part\" : \"GET-FILE-CONTENT-IN-REPO\", \"pin\" : \"GIT-REPO-METADATA\"}]},
      {\"wire-index\" : 10, \"sources\" : [{\"part\" : \"ITERATOR\", \"pin\" : \"GET-A-PART\"}], \"receivers\" : [{\"part\" : \"JSON-OBJECT-STACKER\", \"pin\" : \"GET-A-PART\"}]},
      {\"wire-index\" : 11, \"sources\" : [{\"part\" : \"COLLECTOR\", \"pin\" : \"INTERMEDIATE-CODE\"}], \"receivers\" : [{\"part\" : \"JAVASCRIPT-BUILDER\", \"pin\" : \"INTERMEDIATE-CODE\"}]},
      {\"wire-index\" : 12, \"sources\" : [{\"part\" : \"COMPILE-COMPOSITE\", \"pin\" : \"GRAPH-AS-JSON\"}], \"receivers\" : [{\"part\" : \"COLLECTOR\", \"pin\" : \"COMPOSITE\"}]},
      {\"wire-index\" : 13, \"sources\" : [{\"part\" : \"COMPILE-COMPOSITE\", \"pin\" : \"PARTS-AS-JSON-OBJECTS\"}], \"receivers\" : [{\"part\" : \"JSON-OBJECT-STACKER\", \"pin\" : \"PUSH-OBJECT\"}]},
      {\"wire-index\" : 14, \"sources\" : [{\"part\" : \"JSON-OBJECT-STACKER\", \"pin\" : \"PART-METADATA\"}], \"receivers\" : [{\"part\" : \"ITERATOR\", \"pin\" : \"CONTINUE\"},{\"part\" : \"FETCH-GIT-REPO\", \"pin\" : \"GIT-REPO-METADATA\"}]},
      {\"wire-index\" : 15, \"sources\" : [{\"part\" : \"JSON-OBJECT-STACKER\", \"pin\" : \"NO-MORE\"}], \"receivers\" : [{\"part\" : \"COLLECTOR\", \"pin\" : \"DONE\"},{\"part\" : \"ITERATOR\", \"pin\" : \"DONE\"}]}
    ]
  }"

))
    (with-input-from-string (strm str)
      (let ((lisp (json:decode-json strm)))
        lisp))))

#+nil(defun jtest ()
  (let ((meta "[{\"dir\":\"build_process/\",\"kindName\":\"get file content in repo\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/get_file_content_in_repo.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"iterator\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/parts/iterator.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"compile composite\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/compile_composite.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"json object stacker\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/json_object_stacker.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"determine kind type\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/determine_kind_type.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"collector\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/collector.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"javascript builder\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/javascript_builder.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"fetch git repo\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/fetch_git_repo.json\",\"ref\":\"master\"},{\"dir\":\"build_process/\",\"kindName\":\"prepare temp directory\",\"repo\":\"https://github.com/bmfbp/bmfbp.git\",\"file\":\"parts/prepare_temp_directory.json\",\"ref\":\"master\"}]")
        )

    (with-input-from-string (strm meta)
      (let ((lisp (json:decode-json strm)))
        (pprint lisp)
        (terpri)
        (pprint (json:encode-json lisp))))))