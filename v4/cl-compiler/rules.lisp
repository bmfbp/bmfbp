(in-package :arrowgrams/compiler)

(defparameter *rules*
'
(((:NONAME (:? PORT)) (:PORTNAMEBYID (:? PORT) (:? NAMEID)) :! :FAIL)
 ((:NONAME (:? PORT)))
 ((:NOT_SAME (:? X) (:? X)) :! :FAIL)
 ((:NOT_SAME (:? X) (:? Y)))
 ((:NOT_USED (:? X)) (:USED (:? X)) :! :FAIL)
 ((:NOT_USED (:? X)))
 ((:NOT_NAMEDSINK (:? X)) (:NAMEDSINK (:? X)) :! :FAIL)
 ((:NOT_NAMEDSINK (:? X)))
 ((:WSPC) (:LISP (ARROWGRAMS/COMPILER::OUT " ")) :!)
 ((:NLE) (:LISP (ARROWGRAMS/COMPILER::OUT-NL)) :!)
 ((:WE (:? WE_ARG)) (:LISP (ARROWGRAMS/COMPILER::OUT (:? WE_ARG))) :!)
 ((:WEN (:? WEN_ARG)) (:WE (:? WEN_ARG)) (:NLE) :!)
 ((:CALC_BOUNDS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CREATEBOUNDINGBOXES)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CREATEBOUNDINGBOXES)
  (:CONDITIONALCREATEELLIPSEBB)
  (:CONDRECT)
  (:CONDSPEECH)
  (:CONDTEXT))
 ((:CONDRECT)
  (:FORALL (:RECT (:? ID)) (:CREATERECTBOUNDINGBOX (:? ID))))
 ((:CONDSPEECH)
  (:FORALL (:SPEECHBUBBLE (:? ID)) (:CREATERECTBOUNDINGBOX (:? ID))))
 ((:CONDTEXT)
  (:FORALL
   (:TEXT (:? ID) (:? DONTCARE_37051))
   (:CREATETEXTBOUNDINGBOX (:? ID))))
 ((:CONDITIONALCREATEELLIPSEBB)
  (:ELLIPSE (:? DONTCARE_37052))
  (:FORALL (:ELLIPSE (:? ID)) (:CREATEELLIPSEBOUNDINGBOX (:? ID))))
 ((:CREATERECTBOUNDINGBOX (:? ID))
  (:GEOMETRY_LEFT_X (:? ID) (:? X))
  (:GEOMETRY_TOP_Y (:? ID) (:? Y))
  (:GEOMETRY_W (:? ID) (:? WIDTH))
  (:GEOMETRY_H (:? ID) (:? HEIGHT))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? X))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? Y))))
  (:LISPV (:? RIGHT) (+ (:? X) (:? WIDTH)))
  (:LISPV (:? BOTTOM) (+ (:? Y) (:? HEIGHT)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_RIGHT
                                  (:? ID)
                                  (:? RIGHT))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_BOTTOM
                                  (:? ID)
                                  (:? BOTTOM)))))
 ((:CREATETEXTBOUNDINGBOX (:? ID))
  (:GEOMETRY_CENTER_X (:? ID) (:? CX))
  (:GEOMETRY_TOP_Y (:? ID) (:? Y))
  (:GEOMETRY_W (:? ID) (:? HALFWIDTH))
  (:GEOMETRY_H (:? ID) (:? HEIGHT))
  (:LISPV (:? X) (- (:? CX) (:? HALFWIDTH)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? X))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? Y))))
  (:LISPV (:? RIGHT) (+ (:? CX) (:? HALFWIDTH)))
  (:LISPV (:? BOTTOM) (+ (:? Y) (:? HEIGHT)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_RIGHT
                                  (:? ID)
                                  (:? RIGHT))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_BOTTOM
                                  (:? ID)
                                  (:? BOTTOM)))))
 ((:CREATEELLIPSEBOUNDINGBOX (:? ID))
  (:GEOMETRY_CENTER_X (:? ID) (:? CX))
  (:GEOMETRY_CENTER_Y (:? ID) (:? CY))
  (:GEOMETRY_W (:? ID) (:? HALFWIDTH))
  (:GEOMETRY_H (:? ID) (:? HALFHEIGHT))
  (:LISPV (:? LEFT) (- (:? CX) (:? HALFWIDTH)))
  (:LISPV (:? TOP) (- (:? CY) (:? HALFHEIGHT)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_LEFT
                                  (:? ID)
                                  (:? LEFT))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? TOP))))
  (:LISPV (:? RIGHT) (+ (:? CX) (:? HALFWIDTH)))
  (:LISPV (:? BOTTOM) (+ (:? CY) (:? HALFHEIGHT)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_RIGHT
                                  (:? ID)
                                  (:? RIGHT))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:BOUNDING_BOX_BOTTOM
                                  (:? ID)
                                  (:? BOTTOM)))))
 ((:ASSIGN_PARENTS_TO_ELLISPSES_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:FORALL
   (:ELLIPSE (:? ELLIPSEID))
   (:MAKEPARENTFORELLIPSE (:? ELLIPSEID)))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:MAKEPARENTFORELLIPSE (:? ELLIPSEID))
  (:COMPONENT (:? COMP))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? COMP) (:? ELLIPSEID)))))
 ((:FIND_COMMENTS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CONDCOMMENT)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CONDCOMMENT)
  (:FORALL (:SPEECHBUBBLE (:? ID)) (:CREATECOMMENTS (:? ID))))
 ((:CREATECOMMENTS (:? BUBBLEID))
  (:TEXT (:? TEXTID) (:? DONTCARE_37053))
  (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BUBBLEID))
  :!
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:USED (:? TEXTID))))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:COMMENT (:? TEXTID)))))
 ((:CREATECOMMENTS (:? DONTCARE_37054))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG "fATAL" :COMMENTFINDERFAILED)))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BUBBLEID))
  (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BUBBLEID)))
 ((:FIND_METADATA_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CONDMETA)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CONDMETA)
  (:METADATA (:? MID) (:? TEXTID))
  (:RECT (:? BOXID))
  (:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))
  :!
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:USED (:? TEXTID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:ROUNDEDRECT (:? BOXID))))
  (:COMPONENT (:? MAIN))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? MAIN) (:? BOXID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? BOXID) :BOX_IS_META_DATA)))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::RETRACT (:RECT (:? BOXID))))
  :FAIL)
 ((:CREATEMETADATARECT (:? MID))
  (:METADATA (:? MID) (:? TEXTID))
  (:RECT (:? BOXID))
  (:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:USED (:? TEXTID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:ROUNDEDRECT (:? BOXID))))
  (:COMPONENT (:? MAIN))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? MAIN) (:? BOXID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? BOXID) :BOX_IS_META_DATA)))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::RETRACT (:RECT (:? BOXID)))))
 ((:CREATEMETADATARECT (:? TEXTID))
  (:WEN " ")
  (:WE "createMetaDataRect failed ")
  (:WEN (:? TEXTID)))
 ((:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))
  (:CENTERCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID)))
 ((:ADD_KINDS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CONDDOKINDS)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CONDDOKINDS)
  (:ELTYPE (:? BOXID) :BOX)
  (:TEXT (:? TEXTID) (:? STR))
  (:NOT_USED (:? TEXTID))
  (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID))
  :!
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:USED (:? TEXTID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:KIND (:? BOXID) (:? STR)))))
 ((:CREATEALLKINDS (:? BOXID))
  (:TEXT (:? TEXTID) (:? DONTCARE_37055))
  (:CREATEONEKIND (:? BOXID) (:? TEXTID))
  :FAIL)
 ((:CREATEALLKINDS (:? DONTCARE_37056))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CREATEONEKIND (:? BOXID) (:? TEXTID))
  (:TEXT (:? TEXTID) (:? STR))
  (:NOT_USED (:? TEXTID))
  (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:USED (:? TEXTID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:KIND (:? BOXID) (:? STR)))))
 ((:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID))
  (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID)))
 ((:ADD_SELFPORTS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CONDELLIPSES)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CONDELLIPSES)
  (:ELLIPSE (:? ELLIPSEID))
  (:PORT (:? PORTID))
  (:BOUNDING_BOX_LEFT (:? ELLIPSEID) (:? ELEFTX))
  (:BOUNDING_BOX_TOP (:? ELLIPSEID) (:? ETOPY))
  (:BOUNDING_BOX_RIGHT (:? ELLIPSEID) (:? ERIGHTX))
  (:BOUNDING_BOX_BOTTOM (:? ELLIPSEID) (:? EBOTTOMY))
  (:BOUNDING_BOX_LEFT (:? PORTID) (:? PORTLEFTX))
  (:BOUNDING_BOX_TOP (:? PORTID) (:? PORTTOPY))
  (:BOUNDING_BOX_RIGHT (:? PORTID) (:? PORTRIGHTX))
  (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? PORTBOTTOMY))
  (:PORTTOUCHESELLIPSE
   (:? PORTLEFTX)
   (:? PORTTOPY)
   (:? PORTRIGHTX)
   (:? PORTBOTTOMY)
   (:? ELEFTX)
   (:? ETOPY)
   (:? ERIGHTX)
   (:? EBOTTOMY))
  :!
  (:TEXT (:? NAMEID) (:? NAME))
  (:TEXTCOMPLETELYINSIDE (:? NAMEID) (:? ELLIPSEID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? ELLIPSEID) (:? PORTID))))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:USED (:? NAMEID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PORTNAMEBYID
                                  (:? PORTID)
                                  (:? NAMEID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PORTNAME (:? PORTID) (:? NAME))))
  :FAIL)
 ((:PORTTOUCHESELLIPSE
   (:? PORTLEFTX)
   (:? PORTTOPY)
   (:? PORTRIGHTX)
   (:? PORTBOTTOMY)
   (:? ELEFTX)
   (:? ETOPY)
   (:? DONTCARE_37057)
   (:? EBOTTOMY))
  (:LISP-TRUE-FAIL (<= (:? PORTLEFTX) (:? ELEFTX)))
  (:LISP-TRUE-FAIL (>= (:? PORTRIGHTX) (:? ELEFTX)))
  (:LISP-TRUE-FAIL (>= (:? PORTTOPY) (:? ETOPY)))
  (:LISP-TRUE-FAIL (<= (:? PORTBOTTOMY) (:? EBOTTOMY))))
 ((:PORTTOUCHESELLIPSE
   (:? PORTLEFTX)
   (:? PORTTOPY)
   (:? PORTRIGHTX)
   (:? PORTBOTTOMY)
   (:? ELEFTX)
   (:? ETOPY)
   (:? ERIGHTX)
   (:? DONTCARE_37058))
  (:LISP-TRUE-FAIL (<= (:? PORTTOPY) (:? ETOPY)))
  (:LISP-TRUE-FAIL (>= (:? PORTBOTTOMY) (:? ETOPY)))
  (:LISP-TRUE-FAIL (>= (:? PORTLEFTX) (:? ELEFTX)))
  (:LISP-TRUE-FAIL (<= (:? PORTRIGHTX) (:? ERIGHTX))))
 ((:PORTTOUCHESELLIPSE
   (:? PORTLEFTX)
   (:? PORTTOPY)
   (:? PORTRIGHTX)
   (:? PORTBOTTOMY)
   (:? DONTCARE_37059)
   (:? ETOPY)
   (:? ERIGHTX)
   (:? EBOTTOMY))
  (:LISP-TRUE-FAIL (<= (:? PORTLEFTX) (:? ERIGHTX)))
  (:LISP-TRUE-FAIL (>= (:? PORTRIGHTX) (:? ERIGHTX)))
  (:LISP-TRUE-FAIL (>= (:? PORTTOPY) (:? ETOPY)))
  (:LISP-TRUE-FAIL (<= (:? PORTBOTTOMY) (:? EBOTTOMY))))
 ((:PORTTOUCHESELLIPSE
   (:? PORTLEFTX)
   (:? PORTTOPY)
   (:? PORTRIGHTX)
   (:? PORTBOTTOMY)
   (:? ELEFTX)
   (:? DONTCARE_37060)
   (:? ERIGHTX)
   (:? EBOTTOMY))
  (:LISP-TRUE-FAIL (<= (:? PORTTOPY) (:? EBOTTOMY)))
  (:LISP-TRUE-FAIL (>= (:? PORTBOTTOMY) (:? EBOTTOMY)))
  (:LISP-TRUE-FAIL (>= (:? PORTLEFTX) (:? ELEFTX)))
  (:LISP-TRUE-FAIL (<= (:? PORTRIGHTX) (:? ERIGHTX))))
 ((:TEXTCOMPLETELYINSIDE (:? TEXTID) (:? OBJID))
  (:BOUNDINGBOXCOMPLETELYINSIDE (:? TEXTID) (:? OBJID)))
 ((:MAKE_UNKNOWN_PORT_NAMES_MAIN)
  (:TEXT (:? TEXTID) (:? DONTCARE_37061))
  (:NOT_USED (:? TEXTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:UNASSIGNED (:? TEXTID))))
  :FAIL)
 ((:UNUSED_TEXT (:? TEXTID))
  (:TEXT (:? TEXTID) (:? DONTCARE_37062))
  (:NOT_USED (:? TEXTID)))
 ((:CREATEPORTNAMEIFNOTAKINDNAME (:? TEXTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:UNASSIGNED (:? TEXTID)))))
 ((:CREATE_CENTERS_MAIN)
  (:CREATETEXTCENTERS)
  (:CREATEELLIPSECENTERS)
  (:CREATEPORTCENTERS)
  :FAIL)
 ((:CREATETEXTCENTERS)
  (:UNASSIGNED (:? TEXTID))
  (:CREATECENTER (:? TEXTID)))
 ((:CREATEELLIPSECENTERS) (:ELLIPSE (:? EID)) (:CREATECENTER (:? EID)))
 ((:CREATEPORTCENTERS)
  (:ELTYPE (:? PORTID) :PORT)
  (:CREATECENTER (:? PORTID)))
 ((:CONDITIONALELLIPSECENTERS)
  (:ELLIPSE (:? DONTCARE_37063))
  (:FORALL (:ELLIPSE (:? ID)) (:CREATECENTER (:? ID))))
 ((:CREATECENTER (:? ID))
  (:BOUNDING_BOX_LEFT (:? ID) (:? LEFT))
  (:BOUNDING_BOX_TOP (:? ID) (:? TOP))
  (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT))
  (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))
  (:LISPV (:? W) (- (:? RIGHT) (:? LEFT)))
  (:LISPV (:? TEMP) (/ (:? W) 2))
  (:LISPV (:? X) (+ (:? LEFT) (:? TEMP)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:CENTER_X (:? ID) (:? X))))
  (:LISPV (:? H) (- (:? BOTTOM) (:? TOP)))
  (:LISPV (:? TEMPH) (/ (:? H) 2))
  (:LISPV (:? Y) (+ (:? TOP) (:? TEMPH)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:CENTER_Y (:? ID) (:? Y)))))
 ((:CALCULATE_DISTANCES_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::SET-COUNTER 0))
  :!
  (:ELTYPE (:? PORTID) :PORT)
  (:UNASSIGNED (:? TEXTID))
  (:LISPV (:? NEWID) (ARROWGRAMS/COMPILER::READ-COUNTER))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:JOIN_CENTERPAIR
                                  (:? PORTID)
                                  (:? NEWID))))
  (:LISP (ARROWGRAMS/COMPILER::INC-COUNTER))
  (:CENTER_X (:? PORTID) (:? PX))
  (:CENTER_Y (:? PORTID) (:? PY))
  (:CENTER_X (:? TEXTID) (:? TX))
  (:CENTER_Y (:? TEXTID) (:? TY))
  (:LISPV (:? DX) (- (:? TX) (:? PX)))
  (:LISPV (:? DY) (- (:? TY) (:? PY)))
  (:LISPV (:? DXSQ) (* (:? DX) (:? DX)))
  (:LISPV (:? DYSQ) (* (:? DY) (:? DY)))
  (:LISPV (:? SUM) (+ (:? DXSQ) (:? DYSQ)))
  (:LISPV (:? DISTANCE) (SQRT (:? SUM)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:JOIN_DISTANCE
                                  (:? NEWID)
                                  (:? TEXTID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:DISTANCE_XY
                                  (:? NEWID)
                                  (:? DISTANCE))))
  :FAIL)
 ((:MAKEALLCENTERPAIRS (:? PORTID))
  (:FORALL
   (:UNASSIGNED (:? TEXTID))
   (:MAKECENTERPAIR (:? PORTID) (:? TEXTID))))
 ((:OLD_MAKECENTERPAIR (:? PORTID) (:? TEXTID))
  (:MAKEPAIRID (:? PORTID) (:? JOINPAIRID))
  (:CENTER_X (:? PORTID) (:? PX))
  (:CENTER_Y (:? PORTID) (:? PY))
  (:CENTER_X (:? TEXTID) (:? TX))
  (:CENTER_Y (:? TEXTID) (:? TY))
  (:LISPV (:? DX) (- (:? TX) (:? PX)))
  (:LISPV (:? DY) (- (:? TY) (:? PY)))
  (:LISPV (:? DXSQ) (* (:? DX) (:? DX)))
  (:LISPV (:? DYSQ) (* (:? DY) (:? DY)))
  (:LISPV (:? SUM) (+ (:? DXSQ) (:? DYSQ)))
  (:LISPV (:? DISTANCE) (SQRT (:? SUM)))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:JOIN_DISTANCE
                                  (:? JOINPAIRID)
                                  (:? TEXTID))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:DISTANCE_XY
                                  (:? JOINPAIRID)
                                  (:? DISTANCE)))))
 ((:MAKEPAIRID (:? PORTID) (:? NEWID))
  (:LISPV (:? NEWID) (ARROWGRAMS/COMPILER::READ-COUNTER))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:JOIN_CENTERPAIR
                                  (:? PORTID)
                                  (:? NEWID))))
  (:LISP (ARROWGRAMS/COMPILER::INC-COUNTER)))
 ((:COLLECT_NAMELESS_PORTS
   (:? PORTID)
   (:? LEFT)
   (:? TOP)
   (:? RIGHT)
   (:? BOTTOM))
  (:PORT (:? PORTID))
  (:NONAME (:? PORTID))
  (:BOUNDING_BOX_LEFT (:? PORTID) (:? LEFT))
  (:BOUNDING_BOX_TOP (:? PORTID) (:? TOP))
  (:BOUNDING_BOX_RIGHT (:? PORTID) (:? RIGHT))
  (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? BOTTOM)))
 ((:COLLECT_UNUSED_TEXT
   (:? TEXTID)
   (:? STR)
   (:? LEFT)
   (:? TOP)
   (:? RIGHT)
   (:? BOTTOM))
  (:TEXT (:? TEXTID) (:? STR))
  (:UNUSED_TEXT (:? TEXTID))
  (:BOUNDING_BOX_LEFT (:? TEXTID) (:? LEFT))
  (:BOUNDING_BOX_TOP (:? TEXTID) (:? TOP))
  (:BOUNDING_BOX_RIGHT (:? TEXTID) (:? RIGHT))
  (:BOUNDING_BOX_BOTTOM (:? TEXTID) (:? BOTTOM)))
 ((:COLLECT_UNASSIGNED_TEXT (:? TEXTID) (:? STRID))
  (:TEXT (:? TEXTID) (:? STRID))
  (:UNASSIGNED (:? TEXTID)))
 ((:COLLECT_PORT (:? PORTID)) (:PORT (:? PORTID)))
 ((:COLLECT_JOINS
   (:? JOINID)
   (:? TEXTID)
   (:? PORTID)
   (:? DISTANCE)
   (:? STRID))
  (:JOIN_DISTANCE (:? JOINID) (:? TEXTID))
  (:JOIN_CENTERPAIR (:? PORTID) (:? JOINID))
  (:DISTANCE_XY (:? JOINID) (:? DISTANCE))
  (:TEXT (:? TEXTID) (:? STRID)))
 ((:MARKINDEXEDPORTS_MAIN)
  (:PORTNAME (:? P) (:? DONTCARE_37066))
  (:MARKNAMED (:? P))
  :FAIL)
 ((:MARKNAMED (:? P))
  (:SINK (:? DONTCARE_37067) (:? P))
  :!
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:NAMEDSINK (:? P)))))
 ((:MARKNAMED (:? P))
  (:SOURCE (:? DONTCARE_37068) (:? P))
  :!
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:NAMEDSOURCE (:? P)))))
 ((:COINCIDENTPORTS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:COINCIDENTSINKS)
  (:COINCIDENTSOURCES)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:FINDCOINCIDENTSINK (:? A) (:? B))
  (:NOTNAMEDSINK (:? B))
  :!
  (:NOT_SAME (:? A) (:? B))
  :!
  (:CENTER_X (:? A) (:? AX))
  :!
  (:CENTER_X (:? B) (:? BX))
  :!
  (:CLOSETOGETHER (:? AX) (:? BX))
  (:CENTER_Y (:? A) (:? AY))
  :!
  (:CENTER_Y (:? B) (:? BY))
  :!
  (:CLOSETOGETHER (:? AY) (:? BY))
  (:PORTNAME (:? A) (:? N))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  :COINCIDENTSINK
                                  (:? A)
                                  (:? B)
                                  (:? N))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PORTNAME (:? B) (:? N)))))
 ((:!))
 ((:NOTNAMEDSINK (:? X)) (:NOT_NAMEDSINK (:? X)))
 ((:COINCIDENTSINKS (:? A) (:? B))
  (:NAMEDSINK (:? A))
  (:FINDALLCOINCIDENTSINKS (:? A) (:? B)))
 ((:FINDALLCOINCIDENTSINKS (:? A) (:? B))
  (:SINK (:? DONTCARE_37069) (:? B))
  (:FINDCOINCIDENTSINK (:? A) (:? B))
  :FAIL)
 ((:COINCIDENTSOURCES (:? A) (:? B))
  (:NAMEDSOURCE (:? A))
  (:FINDALLCOINCIDENTSOURCES (:? A) (:? B)))
 ((:FINDALLCOINCIDENTSOURCES (:? A) (:? B))
  (:SOURCE (:? DONTCARE_37070) (:? B))
  (:FINDCOINCIDENTSOURCE (:? A) (:? B))
  :FAIL)
 ((:FINDCOINCIDENTSOURCE (:? A) (:? B))
  (:NOTNAMEDSOURCE (:? B))
  (:NOT_SAME (:? A) (:? B))
  (:CENTER_X (:? A) (:? AX))
  :!
  (:CENTER_X (:? B) (:? BX))
  :!
  (:CLOSETOGETHER (:? AX) (:? BX))
  (:CENTER_Y (:? A) (:? AY))
  :!
  (:CENTER_Y (:? B) (:? BY))
  :!
  (:CLOSETOGETHER (:? AY) (:? BY))
  (:PORTNAME (:? A) (:? N))
  :!
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  :COINCIDENTSOURCE
                                  (:? A)
                                  (:? B)
                                  (:? N))))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PORTNAME (:? B) (:? N))))
  :!)
 ((:NOTNAMEDSOURCE (:? X)) (:NAMEDSOURCE (:? X)) :! :FAIL)
 ((:NOTNAMEDSOURCE (:? X)) (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CLOSETOGETHER (:? X) (:? Y))
  (:LISPV (:? DELTA) (- (:? X) (:? Y)))
  (:LISPV (:? ABS) (ABS (:? DELTA)))
  (:LISP-TRUE-FAIL (>= 20 (:? ABS))))
 ((:CLOSETOGETHER (:? DONTCARE_37071) (:? DONTCARE_37072)) :FAIL)
 ((:MARK_DIRECTIONS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:MATCH_PORTS_TO_COMPONENTS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:MATCH_PORTS)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:MATCH_PORTS_TO_COMPONENTS (:? PORTID))
  (:ELTYPE (:? PORTID) :PORT)
  (:NO_PARENT (:? PORTID))
  (:NEW_ASSIGN_PARENT_FOR_PORT (:? PORTID)))
 ((:NO_PARENT (:? X)) (:PARENT (:? DONTCARE_37073) (:? X)) :! :FAIL)
 ((:NO_PARENT (:? X)))
 ((:NEW_ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:ELLIPSE (:? PARENTID))
  (:PORTINTERSECTION (:? PORTID) (:? PARENTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? PARENTID) (:? PORTID)))))
 ((:NEW_ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:RECT (:? PARENTID))
  (:PORTINTERSECTION (:? PORTID) (:? PARENTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? PARENTID) (:? PORTID)))))
 ((:MARK_NC (:? PORTID))
  (:NO_PARENT (:? PORTID))
  (:ELTYPE (:? PORTID) :PORT)
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? PORTID) "is_nc")))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:N_C (:? PORTID)))))
 ((:ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:PARENT (:? DONTCARE_37074) (:? PORTID))
  :!)
 ((:ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:ELLIPSE (:? PARENTID))
  (:PORTINTERSECTION (:? PORTID) (:? PARENTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? PARENTID) (:? PORTID))))
  :!)
 ((:ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:ELTYPE (:? PARENTID) :BOX)
  (:PORTINTERSECTION (:? PORTID) (:? PARENTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PARENT (:? PARENTID) (:? PORTID))))
  :!)
 ((:ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:PORTNAME (:? PORTID) (:? DONTCARE_37075))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? PORTID) "is_nc")))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:N_C (:? PORTID))))
  :!)
 ((:ASSIGN_PARENT_FOR_PORT (:? PORTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? PORTID) "is_nc")))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:N_C (:? PORTID))))
  :!)
 ((:PORTINTERSECTION (:? PORTID) (:? PARENTID))
  (:BOUNDING_BOX_LEFT (:? PORTID) (:? LEFT))
  :!
  (:BOUNDING_BOX_TOP (:? PORTID) (:? TOP))
  :!
  (:BOUNDING_BOX_RIGHT (:? PORTID) (:? RIGHT))
  :!
  (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? BOTTOM))
  :!
  (:BOUNDING_BOX_LEFT (:? PARENTID) (:? PLEFT))
  :!
  (:BOUNDING_BOX_TOP (:? PARENTID) (:? PTOP))
  :!
  (:BOUNDING_BOX_RIGHT (:? PARENTID) (:? PRIGHT))
  :!
  (:BOUNDING_BOX_BOTTOM (:? PARENTID) (:? PBOTTOM))
  :!
  (:INTERSECTS
   (:? LEFT)
   (:? TOP)
   (:? RIGHT)
   (:? BOTTOM)
   (:? PLEFT)
   (:? PTOP)
   (:? PRIGHT)
   (:? PBOTTOM)))
 ((:INTERSECTS
   (:? PORTLEFT)
   (:? PORTTOP)
   (:? PORTRIGHT)
   (:? PORTBOTTOM)
   (:? PARENTLEFT)
   (:? PARENTTOP)
   (:? PARENTRIGHT)
   (:? PARENTBOTTOM))
  (:LISP-TRUE-FAIL (<= (:? PORTLEFT) (:? PARENTRIGHT)))
  (:LISP-TRUE-FAIL (>= (:? PORTRIGHT) (:? PARENTLEFT)))
  (:LISP-TRUE-FAIL (<= (:? PORTTOP) (:? PARENTBOTTOM)))
  (:LISP-TRUE-FAIL (>= (:? PORTBOTTOM) (:? PARENTTOP))))
 ((:MARK_PINLESS (:? RRECTID))
  (:ROUNDEDRECT (:? RRECTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:PINLESS (:? RRECTID)))))
 ((:NEW_SEM_PARTSHAVESOMEPORTS_MAIN (:? RECTID))
  (:ELTYPE (:? RECTID) :BOX)
  (:NOT_PINLESS (:? RECTID))
  (:NO_PORT (:? RECTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  (:? PARTID)
                                  "error_part_has_no_port"
                                  "partsHaveSomePorts"))))
 ((:NOT_PINLESS (:? R)) (:PINLESS (:? R)) :! :FAIL)
 ((:NOT_PINLESS (:? R)))
 ((:NO_PORT (:? R))
  (:PARENT (:? R) (:? PORT))
  (:PORT (:? PORT))
  :!
  :FAIL)
 ((:NO_PORT (:? R)))
 ((:SEM_PARTSHAVESOMEPORTS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:FORALL (:ELTYPE (:? PARTID) :BOX) (:CHECK_HAS_PORT (:? PARTID)))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CHECK_HAS_PORT (:? PARTID))
  (:PARENT (:? PARTID) (:? PORTID))
  (:PORT (:? PORTID))
  :!)
 ((:CHECK_HAS_PORT (:? PARTID)) (:PINLESS (:? PARTID)) :!)
 ((:CHECK_HAS_PORT (:? PARTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  (:? PARTID)
                                  "error_part_has_no_port"
                                  "partsHaveSomePorts"))))
 ((:SEM_PORTSHAVESINKORSOURCE_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:FORALL (:PORT (:? PORTID)) (:HASSINKORSOURCE (:? PORTID)))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:HASSINKORSOURCE (:? PORTID))
  (:SINK (:? DONTCARE_37076) (:? PORTID))
  :!)
 ((:HASSINKORSOURCE (:? PORTID))
  (:SOURCE (:? DONTCARE_37077) (:? PORTID))
  :!)
 ((:HASSINKORSOURCE (:? PORTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  "fATAL"
                                  :PORT_ISNT_MARKED_SINK_OR_SOURCE
                                  (:? PORTID))))
  :!)
 ((:SEM_NODUPLICATEKINDS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:FORALL
   (:ELTYPE (:? RECTID) :BOX)
   (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID))
  (:KIND (:? RECTID) (:? KIND1))
  (:KIND (:? RECTID) (:? KIND2))
  (:NOT_SAME (:? KIND1) (:? KIND2))
  :!
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  "fATAL_ERRORS_DURING_COMPILATION"
                                  "noDuplicateKinds")))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG "rect " (:? RECTID))))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? KIND1))))
  (:LISP-METHOD (ARROWGRAMS/COMPILER::ASSERTA (:LOG (:? KIND2))))
  (:NLE)
  (:WE "ERROR!!! ")
  (:WE (:? RECTID))
  (:WE " has more than one kind ")
  (:WE (:? KIND1))
  (:WSPC)
  (:WEN (:? KIND2)))
 ((:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID))
  (:KIND (:? RECTID) (:? DONTCARE_37078))
  :!)
 ((:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID))
  (:ROUNDEDRECT (:? RECTID))
  :!)
 ((:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  (:? RECTID)
                                  "has_no_kind"
                                  "noDuplicateKinds")))
  :!)
 ((:SEM_SPEECHVSCOMMENTS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::SET-COUNTER 0))
  (:FORALL (:SPEECHBUBBLE (:? ID)) (:INC :COUNTER (:? DONTCARE_37079)))
  (:FORALL (:COMMENT (:? ID)) (:DEC :COUNTER (:? DONTCARE_37080)))
  (:LISPV (:? COUNTER) (ARROWGRAMS/COMPILER::READ-COUNTER))
  (:CHECKZERO (:? COUNTER))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:CHECKZERO 0) :!)
 ((:CHECKZERO (:? N))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:LOG
                                  "fATAL"
                                  "speechCountCommentCount"
                                  (:? N)))))
 ((:ASSIGN_WIRE_NUMBERS_TO_EDGES_MAIN (:? EDGEID))
  (:LISP (ARROWGRAMS/COMPILER::SET-COUNTER 0))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:EDGE (:? EDGEID))
  (:ASSIGN_WIRE_NUMBER (:? EDGEID))
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:ASSIGN_WIRE_NUMBER (:? EDGEID))
  (:LISPV (:? OLD) (ARROWGRAMS/COMPILER::READ-COUNTER))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:WIRENUM (:? EDGEID) (:? OLD))))
  (:LISP (ARROWGRAMS/COMPILER::INC-COUNTER)))
 ((:SELFINPUTPINS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CONDSOURCEELLIPSE)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:SOURCE_ELLIPSE (:? ELLIPSEID))
  (:ELLIPSE (:? ELLIPSEID))
  (:COMPONENT (:? MAIN))
  (:PARENT (:? MAIN) (:? ELLIPSEID))
  (:PORTFOR (:? ELLIPSEID) (:? PORTID))
  (:SOURCE (:? DONTCARE_37082) (:? PORTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:SELFINPUTPIN (:? PORTID)))))
 ((:SELFOUTPUTPINS_MAIN)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:CONDSINKELLIPSE)
  (:LISP (ARROWGRAMS/COMPILER::TRUE))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:SINK_ELLIPSE (:? ELLIPSEID))
  (:PARENT (:? MAIN) (:? ELLIPSEID))
  (:COMPONENT (:? MAIN))
  (:PORTFOR (:? ELLIPSEID) (:? PORTID))
  (:SINK (:? DONTCARE_37083) (:? PORTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:SELFOUTPUTPIN (:? PORTID)))))
 ((:SINK_RECT (:? RECTID))
  (:RECT (:? RECTID))
  (:PORTFOR (:? RECTID) (:? PORTID))
  (:SINK (:? DONTCARE_37084) (:? PORTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:INPUTPIN (:? RECTID) (:? PORTID)))))
 ((:SOURCE_RECT (:? RECTID))
  (:RECT (:? RECTID))
  (:PORTFOR (:? RECTID) (:? PORTID))
  (:SOURCE (:? DONTCARE_37085) (:? PORTID))
  (:LISP-METHOD
   (ARROWGRAMS/COMPILER::ASSERTA (:OUTPUTPIN
                                  (:? RECTID)
                                  (:? PORTID)))))
 ((:BOUNDINGBOXCOMPLETELYINSIDE (:? ID1) (:? ID2))
  (:BOUNDING_BOX_LEFT (:? ID1) (:? L1))
  (:BOUNDING_BOX_TOP (:? ID1) (:? T1))
  (:BOUNDING_BOX_RIGHT (:? ID1) (:? R1))
  (:BOUNDING_BOX_BOTTOM (:? ID1) (:? B1))
  (:BOUNDING_BOX_LEFT (:? ID2) (:? L2))
  (:BOUNDING_BOX_TOP (:? ID2) (:? T2))
  (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2))
  (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2))
  (:LISP-TRUE-FAIL (>= (:? L1) (:? L2)))
  (:LISP-TRUE-FAIL (>= (:? T1) (:? T2)))
  (:LISP-TRUE-FAIL (>= (:? R2) (:? R1)))
  (:LISP-TRUE-FAIL (>= (:? B2) (:? B1))))
 ((:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? ID1) (:? ID2))
  (:BOUNDING_BOX_LEFT (:? ID1) (:? L1))
  (:BOUNDING_BOX_TOP (:? ID1) (:? T1))
  (:BOUNDING_BOX_LEFT (:? ID2) (:? L2))
  (:BOUNDING_BOX_TOP (:? ID2) (:? T2))
  (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2))
  (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2))
  (:LISP-TRUE-FAIL (>= (:? L1) (:? L2)))
  (:LISP-TRUE-FAIL (>= (:? T1) (:? T2)))
  (:LISP-TRUE-FAIL (>= (:? R2) (:? L1)))
  (:LISP-TRUE-FAIL (>= (:? B2) (:? T1))))
 ((:CENTERCOMPLETELYINSIDEBOUNDINGBOX (:? ID1) (:? ID2))
  (:BOUNDING_BOX_LEFT (:? ID1) (:? L1))
  (:BOUNDING_BOX_TOP (:? ID1) (:? T1))
  (:BOUNDING_BOX_RIGHT (:? ID1) (:? R1))
  (:BOUNDING_BOX_BOTTOM (:? ID1) (:? B1))
  (:LISPV (:? TEMP1) (- (:? R1) (:? L1)))
  (:LISPV (:? CX) (+ (:? L1) (:? TEMP1)))
  (:LISPV (:? TEMP2) (- (:? B1) (:? T1)))
  (:LISPV (:? CY) (+ (:? T1) (:? TEMP2)))
  (:BOUNDING_BOX_LEFT (:? ID2) (:? L2))
  (:BOUNDING_BOX_TOP (:? ID2) (:? T2))
  (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2))
  (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2))
  (:LISP-TRUE-FAIL (>= (:? CX) (:? L2)))
  (:LISP-TRUE-FAIL (<= (:? CX) (:? R2)))
  (:LISP-TRUE-FAIL (>= (:? CY) (:? T2)))
  (:LISP-TRUE-FAIL (<= (:? CY) (:? B2))))
 ((:DUMPLOG)
  (:FORALL (:LOG (:? X)) (:DUMPLOG (:? X)))
  (:FORALL (:LOG (:? Z) (:? Y)) (:DUMPLOG (:? Z) (:? Y)))
  (:FORALL (:LOG (:? A) (:? B) (:? C)) (:DUMPLOG (:? A) (:? B) (:? C)))
  (:FORALL
   (:LOG (:? D) (:? E) (:? F) (:? G))
   (:DUMPLOG (:? D) (:? E) (:? F) (:? G)))
  (:FORALL
   (:LOG (:? H) (:? I) (:? J) (:? K) (:? L))
   (:DUMPLOG (:? H) (:? I) (:? J) (:? K) (:? L)))
  (:FORALL
   (:LOG (:? M) (:? N) (:? O) (:? P) (:? Q) (:? R))
   (:DUMPLOG (:? M) (:? N) (:? O) (:? P) (:? Q) (:? R)))
  (:FORALL
   (:LOG (:? M1) (:? N1) (:? O1) (:? P1) (:? Q1) (:? R1) (:? S1))
   (:DUMPLOG (:? M1) (:? N1) (:? O1) (:? P1) (:? Q1) (:? R1) (:? S1)))
  (:FORALL
   (:LOG
    (:? M2)
    (:? N2)
    (:? O2)
    (:? P2)
    (:? Q2)
    (:? R2)
    (:? S2)
    (:? T2))
   (:DUMPLOG
    (:? M2)
    (:? N2)
    (:? O2)
    (:? P2)
    (:? Q2)
    (:? R2)
    (:? S2)
    (:? T2)))
  (:FORALL
   (:LOG
    (:? L3)
    (:? M3)
    (:? N3)
    (:? O3)
    (:? P3)
    (:? Q3)
    (:? R3)
    (:? S3)
    (:? T3))
   (:DUMPLOG
    (:? L3)
    (:? M3)
    (:? N3)
    (:? O3)
    (:? P3)
    (:? Q3)
    (:? R3)
    (:? S3)
    (:? T3))))
 ((:DUMPLOG (:? W)) (:WEN (:? W)))
 ((:DUMPLOG (:? W) (:? X)) (:WE (:? W)) (:WSPC) (:WEN (:? X)))
 ((:DUMPLOG (:? W) (:? X) (:? Y))
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WEN (:? Y)))
 ((:DUMPLOG (:? W) (:? X) (:? Y) (:? Z))
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WE (:? Y))
  (:WSPC)
  (:WEN (:? Z)))
 ((:DUMPLOG (:? V) (:? W) (:? X) (:? Y) (:? Z))
  (:WE (:? V))
  (:WSPC)
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WE (:? Y))
  (:WSPC)
  (:WEN (:? Z)))
 ((:DUMPLOG
   (:? DONTCARE_37086)
   (:? DONTCARE_37087)
   (:? DONTCARE_37088)
   (:? DONTCARE_37089)
   (:? DONTCARE_37090))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:DUMPLOG (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z))
  (:WE (:? U))
  (:WSPC)
  (:WE (:? V))
  (:WSPC)
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WE (:? Y))
  (:WSPC)
  (:WEN (:? Z)))
 ((:DUMPLOG
   (:? DONTCARE_37091)
   (:? DONTCARE_37092)
   (:? DONTCARE_37093)
   (:? DONTCARE_37094)
   (:? DONTCARE_37095)
   (:? DONTCARE_37096))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:DUMPLOG (:? T) (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z))
  (:WE (:? T))
  (:WSPC)
  (:WE (:? U))
  (:WSPC)
  (:WE (:? V))
  (:WSPC)
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WE (:? Y))
  (:WSPC)
  (:WEN (:? Z)))
 ((:DUMPLOG
   (:? DONTCARE_37097)
   (:? DONTCARE_37098)
   (:? DONTCARE_37099)
   (:? DONTCARE_37100)
   (:? DONTCARE_37101)
   (:? DONTCARE_37102)
   (:? DONTCARE_37103))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:DUMPLOG (:? S) (:? T) (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z))
  (:WE (:? S))
  (:WSPC)
  (:WE (:? T))
  (:WSPC)
  (:WE (:? U))
  (:WSPC)
  (:WE (:? V))
  (:WSPC)
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WE (:? Y))
  (:WSPC)
  (:WEN (:? Z)))
 ((:DUMPLOG
   (:? DONTCARE_37104)
   (:? DONTCARE_37105)
   (:? DONTCARE_37106)
   (:? DONTCARE_37107)
   (:? DONTCARE_37108)
   (:? DONTCARE_37109)
   (:? DONTCARE_37110)
   (:? DONTCARE_37111))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:DUMPLOG
   (:? R)
   (:? S)
   (:? T)
   (:? U)
   (:? V)
   (:? W)
   (:? X)
   (:? Y)
   (:? Z))
  (:WE (:? R))
  (:WSPC)
  (:WE (:? S))
  (:WSPC)
  (:WE (:? T))
  (:WSPC)
  (:WE (:? U))
  (:WSPC)
  (:WE (:? V))
  (:WSPC)
  (:WE (:? W))
  (:WSPC)
  (:WE (:? X))
  (:WSPC)
  (:WE (:? Y))
  (:WSPC)
  (:WEN (:? Z)))
 ((:DUMPLOG
   (:? DONTCARE_37112)
   (:? DONTCARE_37113)
   (:? DONTCARE_37114)
   (:? DONTCARE_37115)
   (:? DONTCARE_37116)
   (:? DONTCARE_37117)
   (:? DONTCARE_37118)
   (:? DONTCARE_37119)
   (:? DONTCARE_37120))
  (:LISP (ARROWGRAMS/COMPILER::TRUE)))
 ((:WSPC) (:LISP (ARROWGRAMS/COMPILER::OUT " ")))
 ((:NLE) (:LISP (ARROWGRAMS/COMPILER::OUT-NL)))
 ((:WE (:? WE_ARG)) (:LISP (ARROWGRAMS/COMPILER::OUT (:? WE_ARG))))
 ((:WEN (:? WEN_ARG)) (:WE (:? WEN_ARG)) (:NLE))
 ((:PORTFOR (:? RECTORELLIPSEID) (:? PORTID))
  (:PARENT (:? RECTORELLIPSEID) (:? PORTID))
  (:PORT (:? PORTID)))
 ((:MATCH_TOP_NAME (:? N)) (:COMPONENT (:? N)))
 ((:FIND_ELLIPSE (:? E)) (:ELLIPSE (:? E)))
 ((:FIND_PARTS (:? ID) (:? STRID))
  (:RECT (:? ID))
  (:KIND (:? ID) (:? STRID)))
 ((:FIND_SELF_INPUT_PINS (:? PORTID) (:? STRID))
  (:SELFINPUTPIN (:? PORTID))
  (:PORTNAME (:? PORTID) (:? STRID)))
 ((:FIND_SELF_OUTPUT_PINS (:? PORTID) (:? STRID))
  (:SELFOUTPUTPIN (:? PORTID))
  (:PORTNAME (:? PORTID) (:? STRID)))
 ((:FIND_PART_INPUT_PINS (:? RECTID) (:? PORTID) (:? STRID))
  (:INPUTPIN (:? RECTID) (:? PORTID))
  (:PORTNAME (:? PORTID) (:? STRID)))
 ((:FIND_PART_OUTPUT_PINS (:? RECTID) (:? PORTID) (:? STRID))
  (:OUTPUTPIN (:? RECTID) (:? PORTID))
  (:PORTNAME (:? PORTID) (:? STRID)))
 ((:FIND_WIRE
   (:? PARENTID1)
   (:? PORTID1)
   (:? PORTNAME1)
   (:? PARENTID2)
   (:? PORTID2)
   (:? PORTNAME2))
  (:EDGE (:? EDGE))
  (:SOURCE (:? EDGE) (:? PORTID1))
  (:SINK (:? EDGE) (:? PORTID2))
  (:PORTNAME (:? PORTID2) (:? PORTNAME2))
  (:PORTNAME (:? PORTID1) (:? PORTNAME1))
  (:PARENT (:? PARENTID2) (:? PORTID2))
  (:PARENT (:? PARENTID1) (:? PORTID1)))
 ((:FETCH_METADATA (:? ID) (:? TEXTID) (:? STR))
  (:METADATA (:? ID) (:? TEXTID))
  (:TEXT (:? TEXTID) (:? STR)))))

