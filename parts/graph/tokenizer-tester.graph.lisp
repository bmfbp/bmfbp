(((:ITEM-KIND . "leaf") (:NAME . "error-crasher") (:IN-PINS "error") (:OUT-PINS) (:KIND . "error-crasher") (:FILENAME . "$/parts/cl/error-crasher.lisp")) ((:ITEM-KIND . "leaf") (:NAME . "token-dumper") (:IN-PINS "token" "eof") (:OUT-PINS "request" "error") (:KIND . "token-dumper") (:FILENAME . "$/parts/cl/token-dumper.lisp")) ((:ITEM-KIND . "leaf") (:NAME . "tokenizer") (:IN-PINS "filename" "request") (:OUT-PINS "token" "eof" "error") (:KIND . "tokenizer") (:FILENAME . "$/parts/cl/tokenizer.lisp")) ((:ITEM-KIND . "graph") (:NAME . "tokenizer-tester") (:GRAPH (:NAME . "TOKENIZER-TESTER") (:INPUTS "FILENAME" "REQUEST") (:OUTPUTS) (:PARTS ((:PART-NAME . "TOKENIZER") (:KIND-NAME . "TOKENIZER")) ((:PART-NAME . "TOKEN-DUMPER") (:KIND-NAME . "TOKEN-DUMPER")) ((:PART-NAME . "ERROR-CRASHER") (:KIND-NAME . "ERROR-CRASHER"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "TOKENIZER") (:PIN . "EOF"))) (:RECEIVERS ((:PART . "TOKEN-DUMPER") (:PIN . "EOF")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "TOKENIZER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "ERROR-CRASHER") (:PIN . "ERROR")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "TOKEN-DUMPER") (:PIN . "REQUEST"))) (:RECEIVERS ((:PART . "TOKENIZER") (:PIN . "REQUEST")))) ((:WIRE-INDEX . 3) (:SOURCES ((:PART . "TOKEN-DUMPER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "ERROR-CRASHER") (:PIN . "ERROR")))) ((:WIRE-INDEX . 4) (:SOURCES ((:PART . "TOKENIZER") (:PIN . "TOKEN"))) (:RECEIVERS ((:PART . "TOKEN-DUMPER") (:PIN . "TOKEN")))) ((:WIRE-INDEX . 5) (:SOURCES ((:PART . "SELF") (:PIN . "FILENAME"))) (:RECEIVERS ((:PART . "TOKENIZER") (:PIN . "FILENAME")))) ((:WIRE-INDEX . 6) (:SOURCES ((:PART . "SELF") (:PIN . "REQUEST"))) (:RECEIVERS ((:PART . "TOKENIZER") (:PIN . "REQUEST"))))))))