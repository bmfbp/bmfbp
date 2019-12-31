(in-package :cl-user)

;(ql:quickload :esrap)


#|
 % from en.wikipedia.org/wiki/Parsing_expression_grammar
 % Pascal nested comment parser
Begin <- '(*'
End   <- '*)'
C     <- Begin N* End
N     <- C / (!Begin !End Z)
Z     <- any single character
|#
(esrap:defrule ruleBegin (and #\( #\*))
(esrap:defrule ruleEnd   (and #\* #\)))
(esrap:defrule ruleC (and ruleBegin (* ruleN) ruleEnd) (:text t))
(esrap:defrule ruleN (or ruleC (and (esrap:! ruleBegin) (esrap:! ruleEnd) ruleZ)))
(esrap:defrule ruleZ character)

(defun pp ()
  (pprint (esrap:parse 'ruleC "(*hello*)"))
  (pprint (esrap:parse 'ruleC "(* which can (* nest *) like this *)")))

#|
%  {a^n b^n c^n : n >= 1}
S <- &(A 'c') 'a'+ B !.
A <- 'a' A? 'b'
B <- 'b' B? 'c'
|#

(esrap:defrule rule-S (and
                       (esrap:& (and rule-A #\c))
                       (+ #\a)
                       rule-B
                       (esrap:! character)))

(esrap:defrule rule-A (and #\a (esrap:? rule-A) #\b))
(esrap:defrule rule-B (and #\b (esrap:? rule-B) #\c))

(defun nn ()
  (pprint (esrap:parse 'rule-S "abc"))
  (pprint (esrap:parse 'rule-S "aabbcc"))
  (pprint (esrap:parse 'rule-S "aaaaabbbbbccccc"))
  #+nil(pprint (esrap:parse 'rule-S "ababbbbaaccccc")) ;; fails (correct)
  #+nil(pprint (esrap:parse 'rule-S "aabbccc")) ;; fails (correct)
  #+nil(pprint (esrap:parse 'rule-S "aabbc")) ;; fails (correct)
  #+nil(pprint (esrap:parse 'rule-S "aabc"))) ;; fails (correct)


#|
 Ford's thesis page 22
E <- N
   / '(' E '+' E ')'
   / '(' E '-' E ')'
N <- D N
   / D
D <- '0' | ... | ''9'
|#

(esrap:defrule rule-E (or rule-N
                          (and #\( rule-E #\+ rule-E #\))
                          (and #\( rule-E #\- rule-E #\)))
  (:text t))

(esrap:defrule rule-N (or (and rule-D rule-N)
                          rule-D))
(esrap:defrule rule-D (esrap:character-ranges (#\0 #\9)))

(defun mm ()
  (esrap:parse 'rule-E "(12-3)"))


