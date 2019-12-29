(defconstant +rules+ 
'(
(:RULE (:NOT-SAME (:? X) (:? X)) :! :FAIL) 
(:RULE (:NOT-SAME (:? X) (:? Y))) 
(:RULE (:CALC_BOUNDS_MAIN) (:CREATEBOUNDINGBOXES)) 
(:RULE (:CREATEBOUNDINGBOXES) (:CONDITIONALCREATEELLIPSEBB) (:CONDRECT) (:CONDSPEECH) (:CONDTEXT)) 
(:RULE (:CONDRECT) (:RECT (:? ID)) (:CREATERECTBOUNDINGBOX (:? ID))) 
(:RULE (:CONDSPEECH) (:SPEECHBUBBLE (:? ID)) (:CREATERECTBOUNDINGBOX (:? ID))) 
(:RULE (:CONDTEXT) (:TEXT (:? ID) (:? DONTCARE-18824)) (:CREATETEXTBOUNDINGBOX (:? ID))) 
(:RULE (:CONDITIONALCREATEELLIPSEBB) (:ELLIPSE (:? DONTCARE-18929)) (:ELLIPSE (:? ID)) (:CREATEELLIPSEBOUNDINGBOX (:? ID))) 
(:RULE (:CREATERECTBOUNDINGBOX (:? ID)) (:GEOMETRY_LEFT_X (:? ID) (:? X)) (:GEOMETRY_TOP_Y (:? ID) (:? Y)) (:GEOMETRY_W (:? ID) (:? WIDTH)) (:GEOMETRY_H (:? ID) (:? HEIGHT)) (:LISP (ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? X)))) (:LISP (ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? Y)))) (:LISPV (:? RIGHT) (+ (:? X) (:? WIDTH))) (:LISPV (:? BOTTOM) (+ (:? Y) (:? HEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)))) (:LISP (ASSERTA (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))))) 
(:RULE (:CREATETEXTBOUNDINGBOX (:? ID)) (:GEOMETRY_CENTER_X (:? ID) (:? CX)) (:GEOMETRY_TOP_Y (:? ID) (:? Y)) (:GEOMETRY_W (:? ID) (:? HALFWIDTH)) (:GEOMETRY_H (:? ID) (:? HEIGHT)) (:LISPV (:? X) (- (:? CX) (:? HALFWIDTH))) (:LISP (ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? X)))) (:LISP (ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? Y)))) (:LISPV (:? RIGHT) (+ (:? CX) (:? HALFWIDTH))) (:LISPV (:? BOTTOM) (+ (:? Y) (:? HEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)))) (:LISP (ASSERTA (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))))) 
(:RULE (:CREATEELLIPSEBOUNDINGBOX (:? ID)) (:GEOMETRY_CENTER_X (:? ID) (:? CX)) (:GEOMETRY_CENTER_Y (:? ID) (:? CY)) (:GEOMETRY_W (:? ID) (:? HALFWIDTH)) (:GEOMETRY_H (:? ID) (:? HALFHEIGHT)) (:LISPV (:? LEFT) (- (:? CX) (:? HALFWIDTH))) (:LISPV (:? TOP) (- (:? CY) (:? HALFHEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? LEFT)))) (:LISP (ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? TOP)))) (:LISPV (:? RIGHT) (+ (:? CX) (:? HALFWIDTH))) (:LISPV (:? BOTTOM) (+ (:? CY) (:? HALFHEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)))) (:LISP (ASSERTA (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))))) 
(:RULE (:ASSIGN_PARENTS_TO_ELLISPSES_MAIN) (:ELLIPSE (:? ELLIPSEID)) (:MAKEPARENTFORELLIPSE (:? ELLIPSEID))) 
(:RULE (:MAKEPARENTFORELLIPSE (:? ELLIPSEID)) (:COMPONENT (:? COMP)) (:LISP (ASSERTA (:PARENT (:? COMP) (:? ELLIPSEID))))) 
(:RULE (:FIND_COMMENTS_MAIN) (:CONDCOMMENT)) 
(:RULE (:CONDCOMMENT) (:SPEECHBUBBLE (:? ID)) (:CREATECOMMENTS (:? ID))) 
(:RULE (:CREATECOMMENTS (:? BUBBLEID)) (:TEXT (:? TEXTID) (:? DONTCARE-22271)) (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BUBBLEID)) (:!) (:LISP (ASSERTA (:USED (:? TEXTID)))) (:LISP (ASSERTA (:COMMENT (:? TEXTID))))) 
(:RULE (:CREATECOMMENTS (:? DONTCARE-22564)) (:LISP (ASSERTA (:LOG "fATAL" :COMMENTFINDERFAILED))) (:LISP T)) 
(:RULE (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BUBBLEID)) (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BUBBLEID))) 
(:RULE (:FIND_METADATA_MAIN) (:CONDMETA)) 
(:RULE (:CONDMETA) (:METADATA (:? MID) (:? DONTCARE-22989)) (:CREATEMETADATARECT (:? MID))) 
(:RULE (:CREATEMETADATARECT (:? MID)) (:METADATA (:? MID) (:? TEXTID)) (:RECT (:? BOXID)) (:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID)) (:LISP (ASSERTA (:USED (:? TEXTID)))) (:LISP (ASSERTA (:ROUNDEDRECT (:? BOXID)))) (:COMPONENT (:? MAIN)) (:LISP (ASSERTA (:PARENT (:? MAIN) (:? BOXID)))) (:LISP (ASSERTA (:LOG (:? BOXID) :BOX_IS_META_DATA))) (:LISP (RETRACT (:RECT (:? BOXID))))) 
(:RULE (:CREATEMETADATARECT (:? TEXTID)) (:WEN " ") (:WE "createMetaDataRect failed ") (:WEN (:? TEXTID))) 
(:RULE (:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID)) (:CENTERCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))) 
(:RULE (:ADD_KINDS_MAIN) (:CONDDOKINDS)) 
(:RULE (:CONDDOKINDS) (:ELTYPE (:? ID) :BOX) (:CREATEALLKINDS (:? ID)) (:!)) 
(:RULE (:CREATEALLKINDS (:? BOXID)) (:TEXT (:? TEXTID) (:? DONTCARE-24420)) (:CREATEONEKIND (:? BOXID) (:? TEXTID))) 
(:RULE (:CREATEONEKIND (:? BOXID) (:? TEXTID)) (:TEXT (:? TEXTID) (:? STR)) (:LISP (NOT (:USED (:? TEXTID)))) (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID)) (:LISP (ASSERTA (:USED (:? TEXTID)))) (:LISP (ASSERTA (:KIND (:? BOXID) (:? STR))))) 
(:RULE (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID)) (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))) 
(:RULE (:ADD_SELFPORTS_MAIN) (:CONDELLIPSES)) 
(:RULE (:CONDELLIPSES) (:ELLIPSE (:? ELLIPSEID)) (:CREATESELFPORTS (:? ELLIPSEID))) 
(:RULE (:CREATESELFPORTS (:? ELLIPSEID)) (:PORT (:? PORTID)) (:BOUNDING_BOX_LEFT (:? ELLIPSEID) (:? ELEFTX)) (:BOUNDING_BOX_TOP (:? ELLIPSEID) (:? ETOPY)) (:BOUNDING_BOX_RIGHT (:? ELLIPSEID) (:? ERIGHTX)) (:BOUNDING_BOX_BOTTOM (:? ELLIPSEID) (:? EBOTTOMY)) (:BOUNDING_BOX_LEFT (:? PORTID) (:? PORTLEFTX)) (:BOUNDING_BOX_TOP (:? PORTID) (:? PORTTOPY)) (:BOUNDING_BOX_RIGHT (:? PORTID) (:? PORTRIGHTX)) (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? PORTBOTTOMY)) (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? ETOPY) (:? ERIGHTX) (:? EBOTTOMY)) (:TEXT (:? NAMEID) (:? NAME)) (:TEXTCOMPLETELYINSIDE (:? NAMEID) (:? ELLIPSEID)) (:!) (:LISP (ASSERTA (:PARENT (:? ELLIPSEID) (:? PORTID)))) (:LISP (ASSERTA (:USED (:? NAMEID)))) (:LISP (ASSERTA (:PORTNAMEBYID (:? PORTID) (:? NAMEID)))) (:LISP (ASSERTA (:PORTNAME (:? PORTID) (:? NAME))))) 
(:RULE (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? ETOPY) (:? DONTCARE-26790) (:? EBOTTOMY)) (<= (:? PORTLEFTX) (:? ELEFTX)) (>= (:? PORTRIGHTX) (:? ELEFTX)) (>= (:? PORTTOPY) (:? ETOPY)) (<= (:? PORTBOTTOMY) (:? EBOTTOMY))) 
(:RULE (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? ETOPY) (:? ERIGHTX) (:? DONTCARE-27178)) (<= (:? PORTTOPY) (:? ETOPY)) (>= (:? PORTBOTTOMY) (:? ETOPY)) (>= (:? PORTLEFTX) (:? ELEFTX)) (<= (:? PORTRIGHTX) (:? ERIGHTX))) 
(:RULE (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? DONTCARE-27482) (:? ETOPY) (:? ERIGHTX) (:? EBOTTOMY)) (<= (:? PORTLEFTX) (:? ERIGHTX)) (>= (:? PORTRIGHTX) (:? ERIGHTX)) (>= (:? PORTTOPY) (:? ETOPY)) (<= (:? PORTBOTTOMY) (:? EBOTTOMY))) 
(:RULE (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? DONTCARE-27870) (:? ERIGHTX) (:? EBOTTOMY)) (<= (:? PORTTOPY) (:? EBOTTOMY)) (>= (:? PORTBOTTOMY) (:? EBOTTOMY)) (>= (:? PORTLEFTX) (:? ELEFTX)) (<= (:? PORTRIGHTX) (:? ERIGHTX))) 
(:RULE (:TEXTCOMPLETELYINSIDE (:? TEXTID) (:? OBJID)) (:BOUNDINGBOXCOMPLETELYINSIDE (:? TEXTID) (:? OBJID))) 
(:RULE (:MAKE_UNKNOWN_PORT_NAMES_MAIN) (:UNUSED_TEXT (:? TEXTID)) (:CREATEPORTNAMEIFNOTAKINDNAME (:? TEXTID))) 
(:RULE (:UNUSED_TEXT (:? TEXTID)) (:TEXT (:? TEXTID) (:? DONTCARE-28510)) (:LISP (NOT (:USED (:? TEXTID))))) 
(:RULE (:CREATEPORTNAMEIFNOTAKINDNAME (:? TEXTID)) (:LISP (ASSERTA (:UNASSIGNED (:? TEXTID))))) 
(:RULE (:CREATE_CENTERS_MAIN) (:UNASSIGNED (:? TEXTID)) (:CREATECENTER (:? TEXTID)) (:CONDITIONALELLIPSECENTERS) (:ELTYPE (:? PORTID) "port") (:CREATECENTER (:? PORTID))) 
(:RULE (:CONDITIONALELLIPSECENTERS) (:ELLIPSE (:? DONTCARE-29071)) (:ELLIPSE (:? ID)) (:CREATECENTER (:? ID))) 
(:RULE (:CREATECENTER (:? ID)) (:BOUNDING_BOX_LEFT (:? ID) (:? LEFT)) (:BOUNDING_BOX_TOP (:? ID) (:? TOP)) (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)) (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM)) (:LISPV (:? W) (- (:? RIGHT) (:? LEFT))) (:LISPV (:? W) (/ (:? W) 2)) (:LISPV (:? X) (+ (:? LEFT) (:? W))) (:LISP (ASSERTA (:CENTER_X (:? ID) (:? X)))) (:LISPV (:? H) (- (:? BOTTOM) (:? TOP))) (:LISPV (:? H) (/ (:? H) 2)) (:LISPV (:? Y) (+ (:? TOP) (:? H))) (:LISP (ASSERTA (:CENTER_Y (:? ID) (:? Y))))) 
(:RULE (:CALCULATE_DISTANCES_MAIN) (:LISP (RESET-COUNTER)) (:ELTYPE (:? PORTID) "port") (:MAKEALLCENTERPAIRS (:? PORTID))) 
(:RULE (:MAKEALLCENTERPAIRS (:? PORTID)) (:UNASSIGNED (:? TEXTID)) (:MAKECENTERPAIR (:? PORTID) (:? TEXTID))) 
(:RULE (:MAKECENTERPAIR (:? PORTID) (:? TEXTID)) (:MAKEPAIRID (:? PORTID) (:? JOINPAIRID)) (:CENTER_X (:? PORTID) (:? PX)) (:CENTER_Y (:? PORTID) (:? PY)) (:CENTER_X (:? TEXTID) (:? TX)) (:CENTER_Y (:? TEXTID) (:? TY)) (:LISPV (:? DX) (- (:? TX) (:? PX))) (:LISPV (:? DY) (- (:? TY) (:? PY))) (:LISPV (:? DXSQ) (* (:? DX) (:? DX))) (:LISPV (:? DYSQ) (* (:? DY) (:? DY))) (:LISPV (:? SUM) (+ (:? DXSQ) (:? DYSQ))) (:LISPV (:? DISTANCE) (:SQRT (:? SUM))) (:LISP (ASSERTA (:JOIN_DISTANCE (:? JOINPAIRID) (:? TEXTID)))) (:LISP (ASSERTA (:DISTANCE_XY (:? JOINPAIRID) (:? DISTANCE))))) 
(:RULE (:MAKEPAIRID (:? PORTID) (:? NEWID)) (:LISPV (:? NEWID) (READ-COUNTER)) (:LISP (ASSERTA (:JOIN_CENTERPAIR (:? PORTID) (:? NEWID)))) (:LISPV (:? DONTCARE-31507) (INC-COUNTER))) 
(:RULE (:MARKINDEXEDPORTS_MAIN) (:PORTNAME (:? P) (:? DONTCARE-31658)) (:MARKNAMED (:? P))) 
(:RULE (:MARKNAMED (:? P)) (:SINK (:? DONTCARE-31814) (:? P)) (:LISP (ASSERTA (:NAMEDSINK (:? P))))) 
(:RULE (:MARKNAMED (:? P)) (:SOURCE (:? DONTCARE-32014) (:? P)) (:LISP (ASSERTA (:NAMEDSOURCE (:? P))))) 
(:RULE (:MARKNAME (:? P)) (:WE "port ") (:WE (:? P)) (:WEN " has no name!")) 
(:RULE (:COINCIDENTPORTS_MAIN) (:COINCIDENTSINKS) (:COINCIDENTSOURCES)) 
(:RULE (:COINCIDENTSINKS) (:NAMEDSINK (:? X)) (:FINDALLCOINCIDENTSINKS (:? X))) 
(:RULE (:FINDALLCOINCIDENTSINKS (:? A)) (:SINK (:? DONTCARE-32610) (:? B)) (:FINDCOINCIDENTSINK (:? A) (:? B))) 
(:RULE (:FINDCOINCIDENTSINK (:? A) (:? B)) (:CENTER_Y (:? A) (:? AY)) (:CENTER_Y (:? B) (:? BY)) (:CENTER_X (:? A) (:? AX)) (:CENTER_X (:? B) (:? BX)) (PROLOG:NOT-SAME (:? A) (:? B)) (:SINK (:? DONTCARE-33112) (:? B)) (:NOTNAMEDSINK (:? B)) (:CLOSETOGETHER (:? AX) (:? BX)) (:CLOSETOGETHER (:? AY) (:? BY)) (:PORTNAME (:? A) (:? N)) (:LISP (ASSERTA (:LOG :COINCIDENTSINK (:? A) (:? B) (:? N)))) (:LISP (ASSERTA (:PORTNAME (:? B) (:? N))))) 
(:RULE (:NOTNAMEDSINK (:? X)) (:LISP (NOT (:NAMEDSINK (:? X))))) 
(:RULE (:COINCIDENTSOURCES) (:NAMEDSOURCE (:? X)) (:FINDALLCOINCIDENTSOURCES (:? X))) 
(:RULE (:FINDALLCOINCIDENTSOURCES (:? A)) (:SOURCE (:? DONTCARE-33940) (:? B)) (:FINDCOINCIDENTSOURCE (:? A) (:? B))) 
(:RULE (:FINDCOINCIDENTSOURCE (:? A) (:? B)) (:CENTER_Y (:? A) (:? AY)) (:CENTER_Y (:? B) (:? BY)) (:CENTER_X (:? A) (:? AX)) (:CENTER_X (:? B) (:? BX)) (PROLOG:NOT-SAME (:? A) (:? B)) (:SOURCE (:? DONTCARE-34442) (:? B)) (:NOTNAMEDSOURCE (:? B)) (:CLOSETOGETHER (:? AX) (:? BX)) (:CLOSETOGETHER (:? AY) (:? BY)) (:PORTNAME (:? A) (:? N)) (:LISP (ASSERTA (:LOG :COINCIDENTSOURCE (:? A) (:? B) (:? N)))) (:LISP (ASSERTA (:PORTNAME (:? B) (:? N))))) 
(:RULE (:NOTNAMEDSOURCE (:? X)) (:LISP (NOT (:NAMEDSOURCE (:? X))))) 
(:RULE (:CLOSETOGETHER (:? X) (:? Y)) (:LISPV (:? DELTA) (- (:? X) (:? Y))) (:LISPV (:? ABS) (:ABS (:? DELTA))) (>= 20 (:? ABS))) 
(:RULE (:CLOSETOGETHER (:? DONTCARE-35360) (:? DONTCARE-35382)) (:LISP NIL)) 
(:RULE (:MARK_DIRECTIONS_MAIN)) 
(:RULE (:MATCH_PORTS_TO_COMPONENTS_MAIN) (:MATCH_PORTS)) 
(:RULE (:MATCH_PORTS) (:ELTYPE (:? PORTID) :PORT) (:ASSIGN_PARENT_FOR_PORT (:? PORTID))) 
(:RULE (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:PARENT (:? DONTCARE-35795) (:? PORTID)) (:!)) 
(:RULE (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:ELLIPSE (:? PARENTID)) (:PORTINTERSECTION (:? PORTID) (:? PARENTID)) (:LISP (ASSERTA (:PARENT (:? PARENTID) (:? PORTID)))) (:!)) 
(:RULE (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:ELTYPE (:? PARENTID) :BOX) (:PORTINTERSECTION (:? PORTID) (:? PARENTID)) (:LISP (ASSERTA (:PARENT (:? PARENTID) (:? PORTID)))) (:!)) 
(:RULE (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:PORTNAME (:? PORTID) (:? DONTCARE-36504)) (:LISP (ASSERTA (:LOG (:? PORTID) "is_nc"))) (:LISP (ASSERTA (:N_C (:? PORTID)))) (:!)) 
(:RULE (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:LISP (ASSERTA (:LOG (:? PORTID) "is_nc"))) (:LISP (ASSERTA (:N_C (:? PORTID)))) (:!)) 
(:RULE (:PORTINTERSECTION (:? PORTID) (:? PARENTID)) (:BOUNDING_BOX_LEFT (:? PORTID) (:? LEFT)) (:BOUNDING_BOX_TOP (:? PORTID) (:? TOP)) (:BOUNDING_BOX_RIGHT (:? PORTID) (:? RIGHT)) (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? BOTTOM)) (:BOUNDING_BOX_LEFT (:? PARENTID) (:? PLEFT)) (:BOUNDING_BOX_TOP (:? PARENTID) (:? PTOP)) (:BOUNDING_BOX_RIGHT (:? PARENTID) (:? PRIGHT)) (:BOUNDING_BOX_BOTTOM (:? PARENTID) (:? PBOTTOM)) (:INTERSECTS (:? LEFT) (:? TOP) (:? RIGHT) (:? BOTTOM) (:? PLEFT) (:? PTOP) (:? PRIGHT) (:? PBOTTOM))) 
(:RULE (:INTERSECTS (:? PORTLEFT) (:? PORTTOP) (:? PORTRIGHT) (:? PORTBOTTOM) (:? PARENTLEFT) (:? PARENTTOP) (:? PARENTRIGHT) (:? PARENTBOTTOM)) (<= (:? PORTLEFT) (:? PARENTRIGHT)) (>= (:? PORTRIGHT) (:? PARENTLEFT)) (<= (:? PORTTOP) (:? PARENTBOTTOM)) (>= (:? PORTBOTTOM) (:? PARENTTOP))) 
(:RULE (:PINLESS_MAIN) (:ELTYPE (:? PARENTID) :BOX) (:CHECK_HAS_PORT (:? PARENTID))) 
(:RULE (:CHECK_HAS_PORT (:? PARENTID)) (:PARENT (:? PARENTID) (:? PORTID)) (:PORT (:? PORTID)) (:!)) 
(:RULE (:CHECK_HAS_PORT (:? PARENTID)) (:ROUNDEDRECT (:? PARENTID)) (:LISP (ASSERTA (:PINLESS (:? PARENTID))))) 
(:RULE (:SEM_PARTSHAVESOMEPORTS_MAIN) (:ELTYPE (:? PARTID) :BOX) (:CHECK_HAS_PORT (:? PARTID))) 
(:RULE (:CHECK_HAS_PORT (:? PARTID)) (:PARENT (:? PARTID) (:? PORTID)) (:PORT (:? PORTID)) (:!)) 
(:RULE (:CHECK_HAS_PORT (:? PARTID)) (:PINLESS (:? PARTID)) (:!)) 
(:RULE (:CHECK_HAS_PORT (:? PARTID)) (:LISP (ASSERTA (:LOG (:? PARTID) "error_part_has_no_port" "partsHaveSomePorts")))) 
(:RULE (:SEM_PORTSHAVESINKORSOURCE_MAIN) (:PORT (:? PORTID)) (:HASSINKORSOURCE (:? PORTID))) 
(:RULE (:HASSINKORSOURCE (:? PORTID)) (:SINK (:? DONTCARE-39558) (:? PORTID)) (:!)) 
(:RULE (:HASSINKORSOURCE (:? PORTID)) (:SOURCE (:? DONTCARE-39685) (:? PORTID)) (:!)) 
(:RULE (:HASSINKORSOURCE (:? PORTID)) (:LISP (ASSERTA (:LOG "fATAL" :PORT_ISNT_MARKED_SINK_OR_SOURCE (:? PORTID)))) (:!)) 
(:RULE (:SEM_NODUPLICATEKINDS_MAIN) (:ELTYPE (:? RECTID) :BOX) (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID))) 
(:RULE (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:KIND (:? RECTID) (:? KIND1)) (:KIND (:? RECTID) (:? KIND2)) ((:? KIND1) PROLOG:NOT-UNIFY-SAME (:? KIND2)) (:!) (:LISP (ASSERTA (:LOG "fATAL_ERRORS_DURING_COMPILATION" "noDuplicateKinds"))) (:LISP (ASSERTA (:LOG "rect " (:? RECTID)))) (:LISP (ASSERTA (:LOG (:? KIND1)))) (:LISP (ASSERTA (:LOG (:? KIND2)))) (:NLE) (:WE "ERROR!!! ") (:WE (:? RECTID)) (:WE " has more than one kind ") (:WE (:? KIND1)) (:WSPC) (:WEN (:? KIND2))) 
(:RULE (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:KIND (:? RECTID) (:? DONTCARE-41005)) (:!)) 
(:RULE (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:ROUNDEDRECT (:? RECTID)) (:!)) 
(:RULE (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:LISP (ASSERTA (:LOG (:? RECTID) "has_no_kind" "noDuplicateKinds"))) (:!)) 
(:RULE (:SEM_SPEECHVSCOMMENTS_MAIN) (:LISP (RESET-COUNTER)) (:SPEECHBUBBLE (:? ID)) (:LISPV (:? DONTCARE-41553) (INC-COUNTER)) (:COMMENT (:? ID)) (:LISPV (:? DONTCARE-41661) (DEC-COUNTER)) (:LISPV (:? COUNTER) (READ-COUNTER)) (:CHECKZERO (:? COUNTER))) 
(:RULE (:CHECKZERO 0) (:!)) 
(:RULE (:CHECKZERO (:? N)) (:LISP (ASSERTA (:LOG "fATAL" "speechCountCommentCount" (:? N))))) 
(:RULE (:ASSIGN_WIRE_NUMBERS_TO_EDGES_MAIN) (:LISP (RESET-COUNTER)) (:EDGE (:? EDGEID)) (:ASSIGN_WIRE_NUMBER (:? EDGEID)) (:LISPV (:? N) (READ-COUNTER)) (:LISP (ASSERTA (:NWIRES (:? N))))) 
(:RULE (:ASSIGN_WIRE_NUMBER (:? EDGEID)) (:LISPV (:? OLD) (READ-COUNTER)) (:LISP (ASSERTA (:WIRENUM (:? EDGEID) (:? OLD)))) (:LISPV (:? DONTCARE-42694) (INC-COUNTER))) 
(:RULE (:SELFINPUTPINS_MAIN) (:CONDSOURCEELLIPSE)) 
(:RULE (:CONDSOURCEELLIPSE) (:ELLIPSE (:? ELLIPSEID)) (:MAKESELFINPUTPINS (:? ELLIPSEID)) (:!)) 
(:RULE (:MAKESELFINPUTPINS (:? ELLIPSEID)) (:PARENT (:? MAIN) (:? ELLIPSEID)) (:COMPONENT (:? MAIN)) (:PORTFOR (:? ELLIPSEID) (:? PORTID)) (:SOURCE (:? DONTCARE-43182) (:? PORTID)) (:LISP (ASSERTA (:SELFINPUTPIN (:? PORTID)))) (:!)) 
(:RULE (:SELFOUTPUTPINS_MAIN) (:CONDSINKELLIPSE)) 
(:RULE (:CONDSINKELLIPSE) (:ELLIPSE (:? ELLIPSEID)) (:MAKESELFOUTPUTPINS (:? ELLIPSEID)) (:!)) 
(:RULE (:MAKESELFOUTPUTPINS (:? ELLIPSEID)) (:PARENT (:? MAIN) (:? ELLIPSEID)) (:COMPONENT (:? MAIN)) (:PORTFOR (:? ELLIPSEID) (:? PORTID)) (:SINK (:? DONTCARE-43778) (:? PORTID)) (:LISP (ASSERTA (:SELFOUTPUTPIN (:? PORTID)))) (:!)) 
(:RULE (:INPUTPINS_MAIN) (:CONDSINKRECT)) 
(:RULE (:CONDSINKRECT) (:RECT (:? RECTID)) (:MAKEINPUTPINS (:? RECTID)) (:!)) 
(:RULE (:MAKEINPUTPINS (:? RECTID)) (:PORTFOR (:? RECTID) (:? PORTID)) (:SINK (:? DONTCARE-44267) (:? PORTID)) (:LISP (ASSERTA (:INPUTPIN (:? PORTID)))) (:!)) 
(:RULE (:OUTPUTPINS_MAIN) (:CONDSOURCERECT)) 
(:RULE (:CONDSOURCERECT) (:RECT (:? RECTID)) (:MAKEOUTPUTPINS (:? RECTID)) (:!)) 
(:RULE (:MAKEOUTPUTPINS (:? RECTID)) (:PORTFOR (:? RECTID) (:? PORTID)) (:SOURCE (:? DONTCARE-44756) (:? PORTID)) (:LISP (ASSERTA (:OUTPUTPIN (:? PORTID)))) (:!)) 
(:RULE (:BOUNDINGBOXCOMPLETELYINSIDE (:? ID1) (:? ID2)) (:BOUNDING_BOX_LEFT (:? ID1) (:? L1)) (:BOUNDING_BOX_TOP (:? ID1) (:? T1)) (:BOUNDING_BOX_RIGHT (:? ID1) (:? R1)) (:BOUNDING_BOX_BOTTOM (:? ID1) (:? B1)) (:BOUNDING_BOX_LEFT (:? ID2) (:? L2)) (:BOUNDING_BOX_TOP (:? ID2) (:? T2)) (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2)) (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2)) (>= (:? L1) (:? L2)) (>= (:? T1) (:? T2)) (>= (:? R2) (:? R1)) (>= (:? B2) (:? B1))) 
(:RULE (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? ID1) (:? ID2)) (:BOUNDING_BOX_LEFT (:? ID1) (:? L1)) (:BOUNDING_BOX_TOP (:? ID1) (:? T1)) (:BOUNDING_BOX_LEFT (:? ID2) (:? L2)) (:BOUNDING_BOX_TOP (:? ID2) (:? T2)) (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2)) (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2)) (>= (:? L1) (:? L2)) (>= (:? T1) (:? T2)) (>= (:? R2) (:? L1)) (>= (:? B2) (:? T1))) 
(:RULE (:CENTERCOMPLETELYINSIDEBOUNDINGBOX (:? ID1) (:? ID2)) (:BOUNDING_BOX_LEFT (:? ID1) (:? L1)) (:BOUNDING_BOX_TOP (:? ID1) (:? T1)) (:BOUNDING_BOX_RIGHT (:? ID1) (:? R1)) (:BOUNDING_BOX_BOTTOM (:? ID1) (:? B1)) (:LISPV (:? CX) (+ (:? L1) (- (:? R1) (:? L1)))) (:LISPV (:? CY) (+ (:? T1) (- (:? B1) (:? T1)))) (:BOUNDING_BOX_LEFT (:? ID2) (:? L2)) (:BOUNDING_BOX_TOP (:? ID2) (:? T2)) (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2)) (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2)) (>= (:? CX) (:? L2)) (<= (:? CX) (:? R2)) (>= (:? CY) (:? T2)) (<= (:? CY) (:? B2))) 
(:RULE (:DUMPLOG) (:LOG (:? X)) (:DUMPLOG (:? X)) (:LOG (:? Z) (:? Y)) (:DUMPLOG (:? Z) (:? Y)) (:LOG (:? A) (:? B) (:? C)) (:DUMPLOG (:? A) (:? B) (:? C)) (:LOG (:? D) (:? E) (:? F) (:? G)) (:DUMPLOG (:? D) (:? E) (:? F) (:? G)) (:LOG (:? H) (:? I) (:? J) (:? K) (:? L)) (:DUMPLOG (:? H) (:? I) (:? J) (:? K) (:? L)) (:LOG (:? M) (:? N) (:? O) (:? P) (:? Q) (:? R)) (:DUMPLOG (:? M) (:? N) (:? O) (:? P) (:? Q) (:? R)) (:LOG (:? M1) (:? N1) (:? O1) (:? P1) (:? Q1) (:? R1) (:? S1)) (:DUMPLOG (:? M1) (:? N1) (:? O1) (:? P1) (:? Q1) (:? R1) (:? S1)) (:LOG (:? M2) (:? N2) (:? O2) (:? P2) (:? Q2) (:? R2) (:? S2) (:? T2)) (:DUMPLOG (:? M2) (:? N2) (:? O2) (:? P2) (:? Q2) (:? R2) (:? S2) (:? T2)) (:LOG (:? L3) (:? M3) (:? N3) (:? O3) (:? P3) (:? Q3) (:? R3) (:? S3) (:? T3)) (:DUMPLOG (:? L3) (:? M3) (:? N3) (:? O3) (:? P3) (:? Q3) (:? R3) (:? S3) (:? T3))) 
(:RULE (:DUMPLOG (:? W)) (:WEN (:? W))) 
(:RULE (:DUMPLOG (:? W) (:? X)) (:WE (:? W)) (:WSPC) (:WEN (:? X))) 
(:RULE (:DUMPLOG (:? W) (:? X) (:? Y)) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WEN (:? Y))) 
(:RULE (:DUMPLOG (:? W) (:? X) (:? Y) (:? Z)) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WE (:? Y)) (:WSPC) (:WEN (:? Z))) 
(:RULE (:DUMPLOG (:? V) (:? W) (:? X) (:? Y) (:? Z)) (:WE (:? V)) (:WSPC) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WE (:? Y)) (:WSPC) (:WEN (:? Z))) 
(:RULE (:DUMPLOG (:? DONTCARE-50720) (:? DONTCARE-50742) (:? DONTCARE-50764) (:? DONTCARE-50786) (:? DONTCARE-50808)) (:LISP T)) 
(:RULE (:DUMPLOG (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z)) (:WE (:? U)) (:WSPC) (:WE (:? V)) (:WSPC) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WE (:? Y)) (:WSPC) (:WEN (:? Z))) 
(:RULE (:DUMPLOG (:? DONTCARE-51323) (:? DONTCARE-51345) (:? DONTCARE-51367) (:? DONTCARE-51389) (:? DONTCARE-51411) (:? DONTCARE-51433)) (:LISP T)) 
(:RULE (:DUMPLOG (:? T) (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z)) (:WE (:? T)) (:WSPC) (:WE (:? U)) (:WSPC) (:WE (:? V)) (:WSPC) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WE (:? Y)) (:WSPC) (:WEN (:? Z))) 
(:RULE (:DUMPLOG (:? DONTCARE-52019) (:? DONTCARE-52041) (:? DONTCARE-52063) (:? DONTCARE-52085) (:? DONTCARE-52107) (:? DONTCARE-52129) (:? DONTCARE-52151)) (:LISP T)) 
(:RULE (:DUMPLOG (:? S) (:? T) (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z)) (:WE (:? S)) (:WSPC) (:WE (:? T)) (:WSPC) (:WE (:? U)) (:WSPC) (:WE (:? V)) (:WSPC) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WE (:? Y)) (:WSPC) (:WEN (:? Z))) 
(:RULE (:DUMPLOG (:? DONTCARE-52808) (:? DONTCARE-52830) (:? DONTCARE-52852) (:? DONTCARE-52874) (:? DONTCARE-52896) (:? DONTCARE-52918) (:? DONTCARE-52940) (:? DONTCARE-52962)) (:LISP T)) 
(:RULE (:DUMPLOG (:? R) (:? S) (:? T) (:? U) (:? V) (:? W) (:? X) (:? Y) (:? Z)) (:WE (:? R)) (:WSPC) (:WE (:? S)) (:WSPC) (:WE (:? T)) (:WSPC) (:WE (:? U)) (:WSPC) (:WE (:? V)) (:WSPC) (:WE (:? W)) (:WSPC) (:WE (:? X)) (:WSPC) (:WE (:? Y)) (:WSPC) (:WEN (:? Z))) 
(:RULE (:DUMPLOG (:? DONTCARE-53690) (:? DONTCARE-53712) (:? DONTCARE-53734) (:? DONTCARE-53756) (:? DONTCARE-53778) (:? DONTCARE-53800) (:? DONTCARE-53822) (:? DONTCARE-53844) (:? DONTCARE-53866)) (:LISP T)) 
(:RULE (:WSPC) (FORMAT *STANDARD-ERROR* "~a~%" PROLOG:USER-ERROR)) 
(:RULE (:NLE) (:NL PROLOG:USER-ERROR)) 
(:RULE (:WE (:? X)) (FORMAT *STANDARD-ERROR* "~a~%" PROLOG:USER-ERROR)) 
(:RULE (:WEN (:? X)) (:WE (:? X)) (:NLE)) 
(:RULE (:PORTFOR (:? RECTORELLIPSEID) (:? PORTID)) (:PARENT (:? RECTORELLIPSEID) (:? PORTID)) (:PORT (:? PORTID))))
)
