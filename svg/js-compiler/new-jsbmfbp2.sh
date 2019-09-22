#!/bin/bash
set -v
# parser
lwpasses $NAME <temp5.lisp >temp6a.lisp
NAME=yyy


#assign_parents_to_ellipses <temp6a.pro >temp6.pro

lisp-to-prolog <temp6a.lisp >temp6.pro

find_comments $NAME <temp6.pro >temp7.pro
find_metadata $NAME <temp7.pro >temp8.pro
add_kinds $NAME <temp8.pro >temp9.pro
add_selfPorts $NAME <temp9.pro >temp10.pro
make_unknown_port_names $NAME <temp10.pro >temp11.pro
create_centers $NAME <temp11.pro >temp12.pro
calculate_distances $NAME <temp12.pro >temp13.pro
assign_portnames $NAME <temp13.pro >temp14.pro
markIndexedPorts $NAME <temp14.pro >temp15.pro
coincidentPorts $NAME <temp15.pro >temp16.pro
mark_directions $NAME <temp16.pro >temp17.pro
match_ports_to_components <temp17.pro >temp18a.pro
pinless <temp18a.pro >temp18.pro

##semantics
sem_partsHaveSomePorts <temp18.pro >temp19.pro
sem_portsHaveSinkOrSource <temp19.pro >temp20a.pro
sem_noDuplicateKinds <temp20a.pro >temp20b.pro
sem_speechVScomments <temp20b.pro >temp20.pro

##emitter
assign_wire_numbers_to_edges $NAME <temp20.pro >temp21.pro
selfInputPins <temp21.pro >temp22a.pro
selfOutputPins <temp22a.pro >temp22b.pro
inputPins <temp22b.pro >temp22c.pro
outputPins <temp22c.pro >temp22.pro


loginfo <temp22.pro >temp25.pro
dumplog <temp25.pro 2>temp.log-unfixed.txt

if grep -q 'ATAL' temp.log-unfixed.txt ; then
    cat temp.log-unfixed.txt
    echo QUIT
    exit 1
else    
    new_emit_js $NAME <temp25.pro >temp26.lisp
    unmap-strings $NAME <temp26.lisp >temp27.lisp
    new_emit_js2 $NAME <temp27.lisp >temp28.json
    sed -f strings.sed <temp.log-unfixed.txt >temp.log.txt
fi
