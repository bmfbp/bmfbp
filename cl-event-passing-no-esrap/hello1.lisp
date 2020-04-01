(in-package :cl-event-passing-user)

(defun hello1 ()
  (@initialize)
  (let ((schem (@new-schematic :name "schem"))
        (producer (@new-terminal :name "producer"))
        (consumer (@new-terminal :name "consumer")))
    (let ((wire (@new-wire :name "wire1" :parent schem)))
      
      (@memo-part schem)
      (@memo-part producer)
      (@memo-part consumer)
      
      (@add-output-pin producer :out)
      (@set-first-time-handler producer #'first-time-send)
      
      (@add-input-pin consumer :in)
      
      (@add-inbound-receiver-to-wire schem wire consumer :in)
      
      (@add-internal-part schem producer)
      (@add-internal-part schem consumer)
      
      (@add-internal-wire schem wire)
      (@add-source schem producer :out wire)
      
      (@start-dispatcher))))
    
        
(defmethod first-time-send ((self a:part))
  (@send self "hello"))
    
