#|

// collapse all white-space runs into single tokens

inputs : [token]
outputs : [out]
var : [line-number]

initially
  line-number = 0
end initially

react (e : event)
  machine
    idle: 
      on token : ws(data)
      on wrapup : send-eof & -> idle
    ignoring: 
      on token : ignore-until-newline(data)
      on wrapup : send-ws & send-eof & -> idle
  end machine
end react


method ws (token) 
  if token.kind = character and 
     (token.text = ' ' or token.text = '\t') 
  then
    self.line-number = token.line-number
    -> ignoring
  else
    out <- token
  end if
end method

method ignore-until-newline(token)
  if token.kind = character and token.text = '\n'
  then
    out <- token
    -> idle
  else
    out <- token
  end if
end method

|#

(in-package :arrowgrams)

(defclass spaces (node)
  ((state :accessor state)
   (line-number :accessor line-number)))


(defmethod initially ((self spaces))
  (setf (state self) :idle)
  (setf (line-number self) 0))

(defmethod react ((self spaces) (e event))
  (ecase (state self)
    (:idle
     (cond ((string= "token" (pin-name (partpin e)))
	    )
	   ((string= "wrapup" (pin-name (partpin e)))
	    )
	   (t (illegal))))
    (:ignoring
