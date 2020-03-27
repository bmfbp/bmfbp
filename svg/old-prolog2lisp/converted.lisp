(PROGN 
(:rule (:CALC_BOUNDS_MAIN) (:CREATEBOUNDINGBOXES)) 
(:rule (:CREATEBOUNDINGBOXES) (:CONDITIONALCREATEELLIPSEBB) (:CONDRECT) (:CONDSPEECH) (:CONDTEXT)) 
(:rule (:CONDRECT) (:RECT (:? ID)) (:CREATERECTBOUNDINGBOX (:? ID))) 
(:rule (:CONDSPEECH) (:SPEECHBUBBLE (:? ID)) (:CREATERECTBOUNDINGBOX (:? ID))) 
(:rule (:CONDTEXT) (:TEXT (:? ID) (:? DONTCARE-18720)) (:CREATETEXTBOUNDINGBOX (:? ID))) 
(:rule (:CONDITIONALCREATEELLIPSEBB) (:ELLIPSE (:? DONTCARE-18825)) (:ELLIPSE (:? ID)) (:CREATEELLIPSEBOUNDINGBOX (:? ID))) 
(:rule (:CREATERECTBOUNDINGBOX (:? ID)) (:GEOMETRY_LEFT_X (:? ID) (:? X)) (:GEOMETRY_TOP_Y (:? ID) (:? Y)) (:GEOMETRY_W (:? ID) (:? WIDTH)) (:GEOMETRY_H (:? ID) (:? HEIGHT)) (:LISP (ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? X)))) (:LISP (ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? Y)))) (:IS :RIGHT (PROLOG:PLUS (:? X) (:? WIDTH))) (:IS :BOTTOM (PROLOG:PLUS (:? Y) (:? HEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)))) (:LISP (ASSERTA (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))))) 
(:rule (:CREATETEXTBOUNDINGBOX (:? ID)) (:GEOMETRY_CENTER_X (:? ID) (:? CX)) (:GEOMETRY_TOP_Y (:? ID) (:? Y)) (:GEOMETRY_W (:? ID) (:? HALFWIDTH)) (:GEOMETRY_H (:? ID) (:? HEIGHT)) (:IS :X (PROLOG:MINUS (:? CX) (:? HALFWIDTH))) (:LISP (ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? X)))) (:LISP (ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? Y)))) (:IS :RIGHT (PROLOG:PLUS (:? CX) (:? HALFWIDTH))) (:IS :BOTTOM (PROLOG:PLUS (:? Y) (:? HEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)))) (:LISP (ASSERTA (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))))) 
(:rule (:CREATEELLIPSEBOUNDINGBOX (:? ID)) (:GEOMETRY_CENTER_X (:? ID) (:? CX)) (:GEOMETRY_CENTER_Y (:? ID) (:? CY)) (:GEOMETRY_W (:? ID) (:? HALFWIDTH)) (:GEOMETRY_H (:? ID) (:? HALFHEIGHT)) (:IS :LEFT (PROLOG:MINUS (:? CX) (:? HALFWIDTH))) (:IS :TOP (PROLOG:MINUS (:? CY) (:? HALFHEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_LEFT (:? ID) (:? LEFT)))) (:LISP (ASSERTA (:BOUNDING_BOX_TOP (:? ID) (:? TOP)))) (:IS :RIGHT (PROLOG:PLUS (:? CX) (:? HALFWIDTH))) (:IS :BOTTOM (PROLOG:PLUS (:? CY) (:? HALFHEIGHT))) (:LISP (ASSERTA (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)))) (:LISP (ASSERTA (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM))))) 
(:rule (:ASSIGN_PARENTS_TO_ELLISPSES_MAIN) (:ELLIPSE (:? ELLIPSEID)) (:MAKEPARENTFORELLIPSE (:? ELLIPSEID))) 
(:rule (:MAKEPARENTFORELLIPSE (:? ELLIPSEID)) (:COMPONENT (:? COMP)) (:LISP (ASSERTA (:PARENT (:? COMP) (:? ELLIPSEID))))) 
(:rule (:FIND_COMMENTS_MAIN) (:CONDCOMMENT)) 
(:rule (:CONDCOMMENT) (:SPEECHBUBBLE (:? ID)) (:CREATECOMMENTS (:? ID))) 
(:rule (:CREATECOMMENTS (:? BUBBLEID)) (:TEXT (:? TEXTID) (:? DONTCARE-22167)) (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BUBBLEID)) :! (:LISP (ASSERTA (:USED (:? TEXTID)))) (:LISP (ASSERTA (:COMMENT (:? TEXTID))))) 
(:rule (:CREATECOMMENTS (:? DONTCARE-22460)) (:LISP (ASSERTA (:LOG "fATAL" :COMMENTFINDERFAILED))) (PROLOG:PL-TRUE)) 
(:rule (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BUBBLEID)) (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BUBBLEID))) 
(:rule (:FIND_METADATA_MAIN) (:CONDMETA)) 
(:rule (:CONDMETA) (:METADATA (:? MID) (:? DONTCARE-22886)) (:CREATEMETADATARECT (:? MID))) 
(:rule (:CREATEMETADATARECT (:? MID)) (:METADATA (:? MID) (:? TEXTID)) (:RECT (:? BOXID)) (:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID)) (:LISP (ASSERTA (:USED (:? TEXTID)))) (:LISP (ASSERTA (:ROUNDEDRECT (:? BOXID)))) (:COMPONENT (:? MAIN)) (:LISP (ASSERTA (:PARENT (:? MAIN) (:? BOXID)))) (:LISP (ASSERTA (:LOG (:? BOXID) :BOX_IS_META_DATA))) (:RETRACT (:RECT (:? BOXID)))) 
(:rule (:CREATEMETADATARECT (:? TEXTID)) (:WEN " ") (:WE "createMetaDataRect failed ") (:WEN (:? TEXTID))) 
(:rule (:METADATACOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID)) (:CENTERCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))) 
(:rule (:ADD_KINDS_MAIN) (:CONDDOKINDS)) 
(:rule (:CONDDOKINDS) (:ELTYPE (:? ID) :BOX) (:CREATEALLKINDS (:? ID)) :!) 
(:rule (:CREATEALLKINDS (:? BOXID)) (:TEXT (:? TEXTID) (:? DONTCARE-24317)) (:CREATEONEKIND (:? BOXID) (:? TEXTID))) 
(:rule (:CREATEONEKIND (:? BOXID) (:? TEXTID)) (:TEXT (:? TEXTID) (:? STR)) (:PLISP (NOT (:USED (:? TEXTID)))) (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID)) (:LISP (ASSERTA (:USED (:? TEXTID)))) (:LISP (ASSERTA (:KIND (:? BOXID) (:? STR))))) 
(:rule (:TEXTCOMPLETELYINSIDEBOX (:? TEXTID) (:? BOXID)) (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? TEXTID) (:? BOXID))) 
(:rule (:ADD_SELFPORTS_MAIN) (:CONDELLIPSES)) 
(:rule (:CONDELLIPSES) (:ELLIPSE (:? ELLIPSEID)) (:CREATESELFPORTS (:? ELLIPSEID))) 
(:rule (:CREATESELFPORTS (:? ELLIPSEID)) (:PORT (:? PORTID)) (:BOUNDING_BOX_LEFT (:? ELLIPSEID) (:? ELEFTX)) (:BOUNDING_BOX_TOP (:? ELLIPSEID) (:? ETOPY)) (:BOUNDING_BOX_RIGHT (:? ELLIPSEID) (:? ERIGHTX)) (:BOUNDING_BOX_BOTTOM (:? ELLIPSEID) (:? EBOTTOMY)) (:BOUNDING_BOX_LEFT (:? PORTID) (:? PORTLEFTX)) (:BOUNDING_BOX_TOP (:? PORTID) (:? PORTTOPY)) (:BOUNDING_BOX_RIGHT (:? PORTID) (:? PORTRIGHTX)) (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? PORTBOTTOMY)) (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? ETOPY) (:? ERIGHTX) (:? EBOTTOMY)) (:TEXT (:? NAMEID) (:? NAME)) (:TEXTCOMPLETELYINSIDE (:? NAMEID) (:? ELLIPSEID)) :! (:LISP (ASSERTA (:PARENT (:? ELLIPSEID) (:? PORTID)))) (:LISP (ASSERTA (:USED (:? NAMEID)))) (:LISP (ASSERTA (:PORTNAMEBYID (:? PORTID) (:? NAMEID)))) (:LISP (ASSERTA (:PORTNAME (:? PORTID) (:? NAME))))) 
(:rule (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? ETOPY) (:? DONTCARE-26687) (:? EBOTTOMY)) (<= (:? PORTLEFTX) (:? ELEFTX)) (>= (:? PORTRIGHTX) (:? ELEFTX)) (>= (:? PORTTOPY) (:? ETOPY)) (<= (:? PORTBOTTOMY) (:? EBOTTOMY))) 
(:rule (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? ETOPY) (:? ERIGHTX) (:? DONTCARE-27075)) (<= (:? PORTTOPY) (:? ETOPY)) (>= (:? PORTBOTTOMY) (:? ETOPY)) (>= (:? PORTLEFTX) (:? ELEFTX)) (<= (:? PORTRIGHTX) (:? ERIGHTX))) 
(:rule (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? DONTCARE-27379) (:? ETOPY) (:? ERIGHTX) (:? EBOTTOMY)) (<= (:? PORTLEFTX) (:? ERIGHTX)) (>= (:? PORTRIGHTX) (:? ERIGHTX)) (>= (:? PORTTOPY) (:? ETOPY)) (<= (:? PORTBOTTOMY) (:? EBOTTOMY))) 
(:rule (:PORTTOUCHESELLIPSE (:? PORTLEFTX) (:? PORTTOPY) (:? PORTRIGHTX) (:? PORTBOTTOMY) (:? ELEFTX) (:? DONTCARE-27767) (:? ERIGHTX) (:? EBOTTOMY)) (<= (:? PORTTOPY) (:? EBOTTOMY)) (>= (:? PORTBOTTOMY) (:? EBOTTOMY)) (>= (:? PORTLEFTX) (:? ELEFTX)) (<= (:? PORTRIGHTX) (:? ERIGHTX))) 
(:rule (:TEXTCOMPLETELYINSIDE (:? TEXTID) (:? OBJID)) (:BOUNDINGBOXCOMPLETELYINSIDE (:? TEXTID) (:? OBJID))) 
(:rule (:MAKE_UNKNOWN_PORT_NAMES_MAIN) (:UNUSED_TEXT (:? TEXTID)) (:CREATEPORTNAMEIFNOTAKINDNAME (:? TEXTID))) 
(:rule (:UNUSED_TEXT (:? TEXTID)) (:TEXT (:? TEXTID) (:? DONTCARE-28407)) (:PLISP (NOT (:USED (:? TEXTID))))) 
(:rule (:CREATEPORTNAMEIFNOTAKINDNAME (:? TEXTID)) (:LISP (ASSERTA (:UNASSIGNED (:? TEXTID))))) 
(:rule (:CREATE_CENTERS_MAIN) (:UNASSIGNED (:? TEXTID)) (:CREATECENTER (:? TEXTID)) (:CONDITIONALELLIPSECENTERS) (:ELTYPE (:? PORTID) "port") (:CREATECENTER (:? PORTID))) 
(:rule (:CONDITIONALELLIPSECENTERS) (:ELLIPSE (:? DONTCARE-28968)) (:ELLIPSE (:? ID)) (:CREATECENTER (:? ID))) 
(:rule (:CREATECENTER (:? ID)) (:BOUNDING_BOX_LEFT (:? ID) (:? LEFT)) (:BOUNDING_BOX_TOP (:? ID) (:? TOP)) (:BOUNDING_BOX_RIGHT (:? ID) (:? RIGHT)) (:BOUNDING_BOX_BOTTOM (:? ID) (:? BOTTOM)) (:IS :W (PROLOG:MINUS (:? RIGHT) (:? LEFT))) (:IS :W (PROLOG:DIV (:? W) 2)) (:IS :X (PROLOG:PLUS (:? LEFT) (:? W))) (:LISP (ASSERTA (:CENTER_X (:? ID) (:? X)))) (:IS :H (PROLOG:MINUS (:? BOTTOM) (:? TOP))) (:IS :H (PROLOG:DIV (:? H) 2)) (:IS :Y (PROLOG:PLUS (:? TOP) (:? H))) (:LISP (ASSERTA (:CENTER_Y (:? ID) (:? Y))))) 
(:rule (:CALCULATE_DISTANCES_MAIN) (:G_ASSIGN :COUNTER 0) (:ELTYPE (:? PORTID) "port") (:MAKEALLCENTERPAIRS (:? PORTID))) 
(:rule (:MAKEALLCENTERPAIRS (:? PORTID)) (:UNASSIGNED (:? TEXTID)) (:MAKECENTERPAIR (:? PORTID) (:? TEXTID))) 
(:rule (:MAKECENTERPAIR (:? PORTID) (:? TEXTID)) (:MAKEPAIRID (:? PORTID) (:? JOINPAIRID)) (:CENTER_X (:? PORTID) (:? PX)) (:CENTER_Y (:? PORTID) (:? PY)) (:CENTER_X (:? TEXTID) (:? TX)) (:CENTER_Y (:? TEXTID) (:? TY)) (:IS :DX (PROLOG:MINUS (:? TX) (:? PX))) (:IS :DY (PROLOG:MINUS (:? TY) (:? PY))) (:IS :DXSQ (PROLOG:MUL (:? DX) (:? DX))) (:IS :DYSQ (PROLOG:MUL (:? DY) (:? DY))) (:IS :SUM (PROLOG:PLUS (:? DXSQ) (:? DYSQ))) (:IS :DISTANCE (:SQRT (:? SUM))) (:LISP (ASSERTA (:JOIN_DISTANCE (:? JOINPAIRID) (:? TEXTID)))) (:LISP (ASSERTA (:DISTANCE_XY (:? JOINPAIRID) (:? DISTANCE))))) 
(:rule (:MAKEPAIRID (:? PORTID) (:? NEWID)) (:G_READ :COUNTER (:? NEWID)) (:LISP (ASSERTA (:JOIN_CENTERPAIR (:? PORTID) (:? NEWID)))) (:INC :COUNTER (:? DONTCARE-31404))) 
(:rule (:ASSIGN_PORTNAMES_MAIN) (:ASSIGNUNASSIGNEDTEXTTOPORTS)) 
(:rule (:ASSIGNUNASSIGNEDTEXTTOPORTS) (:UNASSIGNED (:? TEXTID)) (:ASSIGNPORT (:? TEXTID))) 
(:rule (:ASSIGNPORT (:? TEXTID)) (:MINIMUMDISTANCETOAPORT (:? TEXTID) (:? PORTID)) (:TEXT (:? TEXTID) (:? STR)) (:LISP (ASSERTA (:PORTNAMEBYID (:? PORTID) (:? TEXTID)))) (:LISP (ASSERTA (:PORTNAME (:? PORTID) (:? STR))))) 
(:rule (:MINIMUMDISTANCETOAPORT (:? TEXTID) (:? PORTID)) (:UNASSIGNED (:? TEXTID)) (:FINDALLDISTANCESTOPORTSFROMGIVENUNASSIGNEDTEXT (:? TEXTID) (:? DISTANCEPORTIDLIST)) (:SPLITLISTS (:? DISTANCEPORTIDLIST) (:? DISTANCES) (:? PORTIDS)) (:FINDMINIMUMDISTANCEINLIST (:? DISTANCES) (:? MIN)) (:FINDPOSITIONOFMINIMUMINLIST (:? MIN) (:? DISTANCES) (:? NAME)) (:FINDPORTWITHNAME (:? NAME) (:? PORTIDS) (:? PORTID))) 
(:rule (:FINDALLDISTANCESTOPORTSFROMGIVENUNASSIGNEDTEXT (:? TEXTID) (:? DISTANCEPORTIDPAIRLIST)) (:FINDALL (:? DISTANCEPORTIDPAIR) (:FINDONEDISTANCETOAPORTFROMGIVENUNASSIGNEDTEXT (:? TEXTID) (:? DISTANCEPORTIDPAIR)) (:? DISTANCEPORTIDPAIRLIST))) 
(:rule (:FINDONEDISTANCETOAPORTFROMGIVENUNASSIGNEDTEXT (:? TEXTID) (:? DISTANCEPORTIDPAIR)) (:JOIN_DISTANCE (:? CPID) (:? TEXTID)) (:DISTANCE_XY (:? CPID) (:? DISTANCE)) (:JOIN_CENTERPAIR (:? PORTID) (:? CPID)) ((:? DISTANCEPORTIDPAIR) PROLOG:UNIFY-SAME (PROLOG:PL-LIST ((:? DISTANCE) (:? PORTID))))) 
(:rule (:FINDMINIMUMDISTANCEINLIST (:? DISTANCES) (:? MIN)) (:MIN_LIST (:? DISTANCES) (:? MIN))) 
(:rule (:FINDPOSITIONOFMINIMUMINLIST (:? MIN) (:? LIST) (:? POSITION)) (:NTH (:? POSITION) (:? LIST) (:? MIN))) 
(:rule (:FINDPORTWITHNAME (:? POSITION) (:? PORTS) (:? PORTID)) (:NTH (:? POSITION) (:? PORTS) (:? PORTID))) (:SPLITLISTS (PROLOG:PL-LIST) (PROLOG:PL-LIST) (PROLOG:PL-LIST)) 
(:rule (:SPLITLISTS (PROLOG:PL-LIST ((PROLOG:PL-LIST ((:? N1) (:? ID1)))) (:? TAIL)) (:? NS) (:? IDS)) (:SPLITLISTS (:? TAIL) (:? NLIST) (:? IDLIST)) (:APPEND (PROLOG:PL-LIST ((:? N1))) (:? NLIST) (:? NS)) (:APPEND (PROLOG:PL-LIST ((:? ID1))) (:? IDLIST) (:? IDS))) 
(:rule (:MARKINDEXEDPORTS_MAIN) (:PORTNAME (:? P) (:? DONTCARE-34337)) (:MARKNAMED (:? P))) 
(:rule (:MARKNAMED (:? P)) (:SINK (:? DONTCARE-34493) (:? P)) (:LISP (ASSERTA (:NAMEDSINK (:? P))))) 
(:rule (:MARKNAMED (:? P)) (:SOURCE (:? DONTCARE-34693) (:? P)) (:LISP (ASSERTA (:NAMEDSOURCE (:? P))))) 
(:rule (:MARKNAME (:? P)) (:WE "port ") (:WE (:? P)) (:WEN " has no name!")) 
(:rule (:COINCIDENTPORTS_MAIN) (:COINCIDENTSINKS) (:COINCIDENTSOURCES)) 
(:rule (:COINCIDENTSINKS) (:NAMEDSINK (:? X)) (:FINDALLCOINCIDENTSINKS (:? X))) 
(:rule (:FINDALLCOINCIDENTSINKS (:? A)) (:SINK (:? DONTCARE-35289) (:? B)) (:FINDCOINCIDENTSINK (:? A) (:? B))) 
(:rule (:FINDCOINCIDENTSINK (:? A) (:? B)) (:CENTER_Y (:? A) (:? AY)) (:CENTER_Y (:? B) (:? BY)) (:CENTER_X (:? A) (:? AX)) (:CENTER_X (:? B) (:? BX)) (PROLOG:NOT-SAME (:? A) (:? B)) (:SINK (:? DONTCARE-35791) (:? B)) (:NOTNAMEDSINK (:? B)) (:CLOSETOGETHER (:? AX) (:? BX)) (:CLOSETOGETHER (:? AY) (:? BY)) (:PORTNAME (:? A) (:? N)) (:LISP (ASSERTA (:LOG :COINCIDENTSINK (:? A) (:? B) (:? N)))) (:LISP (ASSERTA (:PORTNAME (:? B) (:? N))))) 
(:rule (:NOTNAMEDSINK (:? X)) (:PLISP (NOT (:NAMEDSINK (:? X))))) 
(:rule (:COINCIDENTSOURCES) (:NAMEDSOURCE (:? X)) (:FINDALLCOINCIDENTSOURCES (:? X))) 
(:rule (:FINDALLCOINCIDENTSOURCES (:? A)) (:SOURCE (:? DONTCARE-36619) (:? B)) (:FINDCOINCIDENTSOURCE (:? A) (:? B))) 
(:rule (:FINDCOINCIDENTSOURCE (:? A) (:? B)) (:CENTER_Y (:? A) (:? AY)) (:CENTER_Y (:? B) (:? BY)) (:CENTER_X (:? A) (:? AX)) (:CENTER_X (:? B) (:? BX)) (PROLOG:NOT-SAME (:? A) (:? B)) (:SOURCE (:? DONTCARE-37121) (:? B)) (:NOTNAMEDSOURCE (:? B)) (:CLOSETOGETHER (:? AX) (:? BX)) (:CLOSETOGETHER (:? AY) (:? BY)) (:PORTNAME (:? A) (:? N)) (:LISP (ASSERTA (:LOG :COINCIDENTSOURCE (:? A) (:? B) (:? N)))) (:LISP (ASSERTA (:PORTNAME (:? B) (:? N))))) 
(:rule (:NOTNAMEDSOURCE (:? X)) (:PLISP (NOT (:NAMEDSOURCE (:? X))))) 
(:rule (:CLOSETOGETHER (:? X) (:? Y)) (:IS :DELTA (PROLOG:MINUS (:? X) (:? Y))) (:IS :ABS (:ABS (:? DELTA))) (>= 20 (:? ABS))) 
(:rule (:CLOSETOGETHER (:? DONTCARE-38039) (:? DONTCARE-38061)) (PROLOG:PL-FAIL)) 
(:rule (:MARK_DIRECTIONS_MAIN)) 
(:rule (:MATCH_PORTS_TO_COMPONENTS_MAIN) (:MATCH_PORTS)) 
(:rule (:MATCH_PORTS) (:ELTYPE (:? PORTID) :PORT) (:ASSIGN_PARENT_FOR_PORT (:? PORTID))) 
(:rule (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:PARENT (:? DONTCARE-38475) (:? PORTID)) :!) 
(:rule (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:ELLIPSE (:? PARENTID)) (:PORTINTERSECTION (:? PORTID) (:? PARENTID)) (:LISP (ASSERTA (:PARENT (:? PARENTID) (:? PORTID)))) :!) 
(:rule (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:ELTYPE (:? PARENTID) :BOX) (:PORTINTERSECTION (:? PORTID) (:? PARENTID)) (:LISP (ASSERTA (:PARENT (:? PARENTID) (:? PORTID)))) :!) 
(:rule (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:PORTNAME (:? PORTID) (:? DONTCARE-39184)) (:LISP (ASSERTA (:LOG (:? PORTID) "is_nc"))) (:LISP (ASSERTA (:N_C (:? PORTID)))) :!) 
(:rule (:ASSIGN_PARENT_FOR_PORT (:? PORTID)) (:LISP (ASSERTA (:LOG (:? PORTID) "is_nc"))) (:LISP (ASSERTA (:N_C (:? PORTID)))) :!) 
(:rule (:PORTINTERSECTION (:? PORTID) (:? PARENTID)) (:BOUNDING_BOX_LEFT (:? PORTID) (:? LEFT)) (:BOUNDING_BOX_TOP (:? PORTID) (:? TOP)) (:BOUNDING_BOX_RIGHT (:? PORTID) (:? RIGHT)) (:BOUNDING_BOX_BOTTOM (:? PORTID) (:? BOTTOM)) (:BOUNDING_BOX_LEFT (:? PARENTID) (:? PLEFT)) (:BOUNDING_BOX_TOP (:? PARENTID) (:? PTOP)) (:BOUNDING_BOX_RIGHT (:? PARENTID) (:? PRIGHT)) (:BOUNDING_BOX_BOTTOM (:? PARENTID) (:? PBOTTOM)) (:INTERSECTS (:? LEFT) (:? TOP) (:? RIGHT) (:? BOTTOM) (:? PLEFT) (:? PTOP) (:? PRIGHT) (:? PBOTTOM))) 
(:rule (:INTERSECTS (:? PORTLEFT) (:? PORTTOP) (:? PORTRIGHT) (:? PORTBOTTOM) (:? PARENTLEFT) (:? PARENTTOP) (:? PARENTRIGHT) (:? PARENTBOTTOM)) (<= (:? PORTLEFT) (:? PARENTRIGHT)) (>= (:? PORTRIGHT) (:? PARENTLEFT)) (<= (:? PORTTOP) (:? PARENTBOTTOM)) (>= (:? PORTBOTTOM) (:? PARENTTOP))) 
(:rule (:PINLESS_MAIN) (:ELTYPE (:? PARENTID) :BOX) (:CHECK_HAS_PORT (:? PARENTID))) 
(:rule (:CHECK_HAS_PORT (:? PARENTID)) (:PARENT (:? PARENTID) (:? PORTID)) (:PORT (:? PORTID)) :!) 
(:rule (:CHECK_HAS_PORT (:? PARENTID)) (:ROUNDEDRECT (:? PARENTID)) (:LISP (ASSERTA (:PINLESS (:? PARENTID))))) 
(:rule (:SEM_PARTSHAVESOMEPORTS_MAIN) (:ELTYPE (:? PARTID) :BOX) (:CHECK_HAS_PORT (:? PARTID))) 
(:rule (:CHECK_HAS_PORT (:? PARTID)) (:PARENT (:? PARTID) (:? PORTID)) (:PORT (:? PORTID)) :!) 
(:rule (:CHECK_HAS_PORT (:? PARTID)) (:PINLESS (:? PARTID)) :!) 
(:rule (:CHECK_HAS_PORT (:? PARTID)) (:LISP (ASSERTA (:LOG (:? PARTID) "error_part_has_no_port" "partsHaveSomePorts")))) 
(:rule (:SEM_PORTSHAVESINKORSOURCE_MAIN) (:PORT (:? PORTID)) (:HASSINKORSOURCE (:? PORTID))) 
(:rule (:HASSINKORSOURCE (:? PORTID)) (:SINK (:? DONTCARE-42238) (:? PORTID)) :!) 
(:rule (:HASSINKORSOURCE (:? PORTID)) (:SOURCE (:? DONTCARE-42365) (:? PORTID)) :!) 
(:rule (:HASSINKORSOURCE (:? PORTID)) (:LISP (ASSERTA (:LOG "fATAL" :PORT_ISNT_MARKED_SINK_OR_SOURCE (:? PORTID)))) :!) 
(:rule (:SEM_NODUPLICATEKINDS_MAIN) (:ELTYPE (:? RECTID) :BOX) (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID))) 
(:rule (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:KIND (:? RECTID) (:? KIND1)) (:KIND (:? RECTID) (:? KIND2)) ((:? KIND1) PROLOG:NOT-UNIFY-SAME (:? KIND2)) :! (:LISP (ASSERTA (:LOG "fATAL_ERRORS_DURING_COMPILATION" "noDuplicateKinds"))) (:LISP (ASSERTA (:LOG "rect " (:? RECTID)))) (:LISP (ASSERTA (:LOG (:? KIND1)))) (:LISP (ASSERTA (:LOG (:? KIND2)))) (:NLE) (:WE "ERROR!!! ") (:WE (:? RECTID)) (:WE " has more than one kind ") (:WE (:? KIND1)) (:WSPC) (:WEN (:? KIND2))) 
(:rule (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:KIND (:? RECTID) (:? DONTCARE-43685)) :!) 
(:rule (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:ROUNDEDRECT (:? RECTID)) :!) 
(:rule (:CHECK_HAS_EXACTLY_ONE_KIND (:? RECTID)) (:LISP (ASSERTA (:LOG (:? RECTID) "has_no_kind" "noDuplicateKinds"))) :!) 
(:rule (:SEM_SPEECHVSCOMMENTS_MAIN) (:G_ASSIGN :COUNTER 0) (:SPEECHBUBBLE (:? ID)) (:XINC (:? ID)) (:COMMENT (:? ID)) (:XDEC (:? ID)) (:G_READ :COUNTER (:? COUNTER)) (:CHECKZERO (:? COUNTER))) 
(:rule (:XINC (:? DONTCARE-44480)) (:INC :COUNTER (:? DONTCARE-44539))) 
(:rule (:XDEC (:? DONTCARE-44601)) (:DEC :COUNTER (:? DONTCARE-44660))) 
(:rule (:CHECKZERO 0) :!) 
(:rule (:CHECKZERO (:? N)) (:LISP (ASSERTA (:LOG "fATAL" "speechCountCommentCount" (:? N))))) 
(:rule (:ASSIGN_WIRE_NUMBERS_TO_EDGES_MAIN) (:G_ASSIGN :COUNTER 0) (:EDGE (:? EDGEID)) (:ASSIGN_WIRE_NUMBER (:? EDGEID)) (:G_READ :COUNTER (:? N)) (:LISP (ASSERTA (:NWIRES (:? N))))) 
(:rule (:ASSIGN_WIRE_NUMBER (:? EDGEID)) (:G_READ :COUNTER (:? OLD)) (:LISP (ASSERTA (:WIRENUM (:? EDGEID) (:? OLD)))) (:INC :COUNTER (:? DONTCARE-45572))) 
(:rule (:SELFINPUTPINS_MAIN) (:CONDSOURCEELLIPSE)) 
(:rule (:CONDSOURCEELLIPSE) (:ELLIPSE (:? ELLIPSEID)) (:MAKESELFINPUTPINS (:? ELLIPSEID)) :!) 
(:rule (:MAKESELFINPUTPINS (:? ELLIPSEID)) (:PARENT (:? MAIN) (:? ELLIPSEID)) (:COMPONENT (:? MAIN)) (:PORTFOR (:? ELLIPSEID) (:? PORTID)) (:SOURCE (:? DONTCARE-46060) (:? PORTID)) (:LISP (ASSERTA (:SELFINPUTPIN (:? PORTID)))) :!) 
(:rule (:SELFOUTPUTPINS_MAIN) (:CONDSINKELLIPSE)) 
(:rule (:CONDSINKELLIPSE) (:ELLIPSE (:? ELLIPSEID)) (:MAKESELFOUTPUTPINS (:? ELLIPSEID)) :!) 
(:rule (:MAKESELFOUTPUTPINS (:? ELLIPSEID)) (:PARENT (:? MAIN) (:? ELLIPSEID)) (:COMPONENT (:? MAIN)) (:PORTFOR (:? ELLIPSEID) (:? PORTID)) (:SINK (:? DONTCARE-46656) (:? PORTID)) (:LISP (ASSERTA (:SELFOUTPUTPIN (:? PORTID)))) :!) 
(:rule (:INPUTPINS_MAIN) (:CONDSINKRECT)) 
(:rule (:CONDSINKRECT) (:RECT (:? RECTID)) (:MAKEINPUTPINS (:? RECTID)) :!) 
(:rule (:MAKEINPUTPINS (:? RECTID)) (:PORTFOR (:? RECTID) (:? PORTID)) (:SINK (:? DONTCARE-47145) (:? PORTID)) (:LISP (ASSERTA (:INPUTPIN (:? PORTID)))) :!) 
(:rule (:OUTPUTPINS_MAIN) (:CONDSOURCERECT)) 
(:rule (:CONDSOURCERECT) (:RECT (:? RECTID)) (:MAKEOUTPUTPINS (:? RECTID)) :!) 
(:rule (:MAKEOUTPUTPINS (:? RECTID)) (:PORTFOR (:? RECTID) (:? PORTID)) (:SOURCE (:? DONTCARE-47634) (:? PORTID)) (:LISP (ASSERTA (:OUTPUTPIN (:? PORTID)))) :!) 
(:rule (:INC (:? VAR) (:? VALUE)) (:G_READ (:? VAR) (:? VALUE)) (:IS :X (PROLOG:PLUS (:? VALUE) 1)) (:G_ASSIGN (:? VAR) (:? X))) 
(:rule (:DEC (:? VAR) (:? VALUE)) (:G_READ (:? VAR) (:? VALUE)) (:IS :X (PROLOG:MINUS (:? VALUE) 1)) (:G_ASSIGN (:? VAR) (:? X))) 
(:rule (:BOUNDINGBOXCOMPLETELYINSIDE (:? ID1) (:? ID2)) (:BOUNDING_BOX_LEFT (:? ID1) (:? L1)) (:BOUNDING_BOX_TOP (:? ID1) (:? T1)) (:BOUNDING_BOX_RIGHT (:? ID1) (:? R1)) (:BOUNDING_BOX_BOTTOM (:? ID1) (:? B1)) (:BOUNDING_BOX_LEFT (:? ID2) (:? L2)) (:BOUNDING_BOX_TOP (:? ID2) (:? T2)) (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2)) (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2)) (>= (:? L1) (:? L2)) (>= (:? T1) (:? T2)) (>= (:? R2) (:? R1)) (>= (:? B2) (:? B1))) 
(:rule (:POINTCOMPLETELYINSIDEBOUNDINGBOX (:? ID1) (:? ID2)) (:BOUNDING_BOX_LEFT (:? ID1) (:? L1)) (:BOUNDING_BOX_TOP (:? ID1) (:? T1)) (:BOUNDING_BOX_LEFT (:? ID2) (:? L2)) (:BOUNDING_BOX_TOP (:? ID2) (:? T2)) (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2)) (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2)) (>= (:? L1) (:? L2)) (>= (:? T1) (:? T2)) (>= (:? R2) (:? L1)) (>= (:? B2) (:? T1))) 
(:rule (:CENTERCOMPLETELYINSIDEBOUNDINGBOX (:? ID1) (:? ID2)) (:BOUNDING_BOX_LEFT (:? ID1) (:? L1)) (:BOUNDING_BOX_TOP (:? ID1) (:? T1)) (:BOUNDING_BOX_RIGHT (:? ID1) (:? R1)) (:BOUNDING_BOX_BOTTOM (:? ID1) (:? B1)) (:IS :CX (PROLOG:PLUS (:? L1) (PROLOG:MINUS (:? R1) (:? L1)))) (:IS :CY (PROLOG:PLUS (:? T1) (PROLOG:MINUS (:? B1) (:? T1)))) (:BOUNDING_BOX_LEFT (:? ID2) (:? L2)) (:BOUNDING_BOX_TOP (:? ID2) (:? T2)) (:BOUNDING_BOX_RIGHT (:? ID2) (:? R2)) (:BOUNDING_BOX_BOTTOM (:? ID2) (:? B2)) (>= (:? CX) (:? L2)) (<= (:? CX) (:? R2)) (>= (:? CY) (:? T2)) (<= (:? CY) (:? B2))))