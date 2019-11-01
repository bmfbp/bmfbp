(eval-when (:compile-toplevel :load-toplevel :execute)
  (peg:into-package :diagram))

(in-package :diagram)


;dString <- DQuote NotDQuote* DQuote
;DQuote <- [\"]
;NotDQuote <- ! DQuote .

;   <g transform="translate(50, 60)">
;    <ellipse cx="50" cy="40" rx="50" ry="40">
;    <rect width="80" height="69">
;    <text>top-level svg
;    </text>

;    <polyline points="0,0 206,-2">
;    </polyline>
; Test <- StartSVG Ellipse Rect Text Polyline EndSVG

(defparameter *svg-grammar* "
Test <- StartSVG Shape* EndSvg

Shape <- Ellipse / Rect / Text / Polyline

Ellipse <- Transform EllipseTag EndEllipseTag EndTransform
Rect <- Transform RectTag EndRectTag EndTransform
Text <- Transform TextTag TextBody EndTextSpacing EndTransform
Polyline <- Transform PolylineTag EndPolyline EndTransform

TextTag <- '<text>' Spacing
TextBody <- NotEndText+
EndTextSpacing <- EndText Spacing
EndText <- '</text>'
NotEndText <- !EndText .

PolylineTag <- '<polyline points=\"' Point+ '\">' Spacing
EndPolyline <- '</polyline>' Spacing

Point <- Num ',' Num

StartSVG <- Spacing '<svg>' Spacing
EndSVG <- '</svg>' Spacing
Transform <- '<g transform=' '\"translate(' TwoNumbers ')\">' Spacing
EndTransform <- '</g>' Spacing
TwoNumbers <- Num ',' Spacing Num 
Num <- NegativeSign* [0-9]+ ('.' [0-9]+)* Spacing
NegativeSign <- '-'
EllipseTag <- '<ellipse cx=\"' Num '\" cy=\"' Num '\" rx=\"' Num '\" ry=\"' Num '\">' Spacing
EndEllipseTag <- '</ellipse>' Spacing
RectTag <- '<rect width=\"' Num '\" height=\"' Num '\">' Spacing
EndRectTag <- '</rect>' Spacing
Spacing <- (WhiteSpace / EndOfLine)*
WhiteSpace <- ' ' / '\\t'
EndOfLine <- '\\r\\n' / '\\n' / '\\r'
"
)

(defun test ()
  (let ((test-as-esrap (peg:fullpeg *svg-grammar*)))
    (mapc #'(lambda (expr)
	      #+nil(pprint expr)
	      (eval expr))
	  (rest test-as-esrap))
    (let ((svg-file "
<svg> 
<g transform=\"translate(50.1, 60.23)\"> 
<ellipse cx=\"-50\" cy=\"-40\" rx=\"50\" ry=\"40\"> 
</ellipse>
</g>
<g transform=\"translate(50.1, 60.23)\"> 
<rect width=\"80\" height=\"69\">
</rect>
</g>
<g transform=\"translate(50.1, 60.23)\">
<text>hello
</text>
</g> 
<g transform=\"translate(50.1, 60.23)\">
<polyline points=\"0,0 206,-2\"></polyline>
</g>
</svg>"))
    ;(let ((svg-file (alexandria:read-file-into-string (asdf:system-relative-pathname :diagram "diagram.svg"))))
      #+nil(esrap:trace-rule 'Test :recursive t)
      (esrap:parse 'Test svg-file))))

#|
;; remember to escape double quotes and backslashes to make the below a legal Lisp string
;; SvgGrammar <- SvgTag WhiteSpace WhiteSpace TranslatedShape EndSvgTag
(defparameter *peg-diagram-syntax-only*
"
SvgGrammar <- SvgTag (TranslatedShape)* EndSvgTag

TranslatedShape <- TransformTag Shape EndTransformTag

TransformTag <- Spacing '<g transform=' dString EndTag

Shape <- Ellipse / Text / Rect / Polyline

Ellipse <- '<ellipse' Spacing 'cx=' dString 'cy=' dString 'rx=' dString 'ry=' dString EndTag EndEllipseTag
Rect <- '<rect' Spacing 'width=' dString 'height=' dString EndTag EndRectTag
Text <- '<text>' .+ EndTextTag
Polyline <- '<polyline' Spacing dString EndPolylineTag

SvgTag <- '<svg>' Spacing
EndSvgTag <- '</svg>'
EndTransformTag <- '</g>'
EndEllipseTag <- '</ellipse>'
EndTextTag <- '</text>'
EndRectTag <- '</rect>'
EndPolylineTag <- '</polyline>'

Spacing <- (WhiteSpace / EndOfLine)
WhiteSpace <- ' ' / '\\t'
EndOfLine <- '\\r\\n' / '\\n' / '\\r'
"
)

(defun test-syntax ()
  (let ((diagram-as-esrap (peg:fullpeg *peg-diagram-syntax-only*)))
    (mapc #'(lambda (expr)
	      (pprint expr)
	      (eval expr))
	  (rest diagram-as-esrap))
    ; (let ((svg-file (alexandria:read-file-into-string (asdf:system-relative-pathname :diagram "diagram.svg"))))
    (let ((svg-file "<svg></svg>"))
      (esrap:trace-rule 'SvgGrammar)
      (esrap:parse 'SvgGrammar svg-file))))

|#
