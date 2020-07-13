#!/bin/bash
defaultFontWidth=12
defaultFontHeight=12
nnnn=$1
firstPointx=$2
firstPointy=$3
lastPointx=$4
lastPointy=$5
sourcePinName=$6
sinkPinName=$7

printf "\n\
edge(edge_$nnnn).\n\
line(edge_$nnnn).\n\
source(edge_$nnnn, source_$nnnn).\n\
eltype(source_$nnnn,port).\n\
port(source_$nnnn).\n\
bounding_box_left(source_$nnnn, `expr $firstPointx - 20`).\n\
bounding_box_top(source_$nnnn, `expr $firstPointy - 20`).\n\
bounding_box_right(source_$nnnn, `expr $firstPointx + 20`).\n\
bounding_box_bottom(source_$nnnn, `expr $firstPointy + 20`).\n\
sink(edge_$nnnn, sink_$nnnn).\n\
eltype(sink_$nnnn,port).\n\
port(sink_$nnnn).\n\
bounding_box_left(sink_$nnnn, `expr $lastPointx - 20`).\n\
bounding_box_top(sink_$nnnn, `expr $lastPointy - 20`).\n\
bounding_box_right(sink_$nnnn, `expr $lastPointx + 20`).\n\
bounding_box_bottom(sink_$nnnn, `expr $lastPointy + 20`).\n\
text(beginText_$nnnn, $sourcePinName).\n\
geometry_center_x(beginText_$nnnn, $firstPointx).\n\
geometry_top_y(beginText_$nnnn, `expr $firstPointy - \( $defaultFontHeight / 2 \)` )).\n\
geometry_w(beginText_$nnnn, `expr \( length $sourcePinName \) \* $defaultFontWidth`).\n\
geometry_h(beginText_$nnnn, $defaultFontHeight).\n\
text(endText_$nnnn, $sinkPinName).\n\
geometry_center_x(endText_$nnnn, $firstPointx).\n\
geometry_top_y(endText_$nnnn, `expr $firstPointy - \( $defaultFontHeight / 2 \)` ).\n\
geometry_w(endText_$nnnn, `expr \( length $sinkPinName \) \* $defaultFontWidth` ).\n\
geometry_h(endText_$nnnn, $defaultFontHeight).\n\
"
