(defpackage :arrowgrams/compiler
  (:use :cl))

(defpackage :arrowgrams/compiler/util
  (:use :cl))

(defpackage :arrowgrams/compiler/demux
  (:use :cl))

(defpackage :arrowgrams/compiler/classes
  (:use :cl))

(defpackage :arrowgrams/compiler/reader
  (:use :cl))

(defpackage :arrowgrams/compiler/convert-to-keywords
  (:use :cl))

(defpackage :arrowgrams/compiler/writer
  (:use :cl))

(defpackage :arrowgrams/compiler/fb
  (:use :cl))

(defpackage :arrowgrams/compiler/sequencer
  (:use :cl))

(defpackage :arrowgrams/compiler/speechbubble-bounding-boxes
  (:use :cl))

(defpackage :arrowgrams/compiler/assign-parents-to-ellipses
  (:use :cl))

(defpackage :arrowgrams/compiler/find-comments (:use :cl))
(defpackage :arrowgrams/compiler/find-metadata (:use :cl))
(defpackage :arrowgrams/compiler/add-kinds (:use :cl))
(defpackage :arrowgrams/compiler/add-self-ports (:use :cl))
(defpackage :arrowgrams/compiler/make-unknown-port-names (:use :cl))
(defpackage :arrowgrams/compiler/create-centers (:use :cl))
(defpackage :arrowgrams/compiler/calculate-distances (:use :cl))
(defpackage :arrowgrams/compiler/assign-portnames (:use :cl))
(defpackage :arrowgrams/compiler/mark-indexed-ports (:use :cl))
(defpackage :arrowgrams/compiler/coincident-ports (:use :cl))
(defpackage :arrowgrams/compiler/mark-directions (:use :cl))
(defpackage :arrowgrams/compiler/mark-nc (:use :cl))
(defpackage :arrowgrams/compiler/match-ports-to-components (:use :cl))
(defpackage :arrowgrams/compiler/pinless (:use :cl))
(defpackage :arrowgrams/compiler/sem-parts-have-some-ports (:use :cl))
(defpackage :arrowgrams/compiler/sem-ports-have-sink-or-source (:use :cl))
(defpackage :arrowgrams/compiler/sem-no-duplicate-kinds (:use :cl))
(defpackage :arrowgrams/compiler/sem-speech-vs-comments (:use :cl))
(defpackage :arrowgrams/compiler/assign-wire-numbers-to-edges (:use :cl))
(defpackage :arrowgrams/compiler/self-input-pins (:use :cl))
(defpackage :arrowgrams/compiler/self-output-pins (:use :cl))
(defpackage :arrowgrams/compiler/input-pins (:use :cl))
(defpackage :arrowgrams/compiler/output-pins (:use :cl))

(defpackage :arrowgrams/compiler/ir-emitter (:use :cl))
