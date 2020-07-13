#!/bin/bash
nnnn=$1
topLeftx=$2
topLefty=$3
bottomRightx=$4
bottomRighty=$5
kindName=$6
gitUrl=$7
gitRef=$8
contextDir=$9
manifestPath=$10

width=`expr $bottomRightx - $topLeftx`
height=`expr $bottomRighty - $topLefty`
halfWidth=`expr $width / 2`
halfHeight=`expr $height / 2`

printf "\n\
rect(rect_$nnnn).\n\
eltype(rect_$nnnn,box).\n\
geometry_left_x(rect_$nnnn,$topLeftx).\n\
geometry_top_y(rect_$nnnn,$topLefty).\n\
geometry_w(rect_$nnnn,width).\n\
geometry_h(rect_$nnnn,height).\n\
text(Text_$nnnn,$kindName).\n\
geometry_center_x(kindText_$nnnn, `expr $topLeftx +  $halfWidth `).\n\
geometry_$top_y(kindText_$nnnn, $topLefty).\n\
geometry_w(kindText_$nnnn, $width).\n\
geometry_h(kindText_$nnnn, $height).\n\
"

printf "{\"kindName\" : \"%s\"," $kindName >>manifest
printf "\"gitUrl\" : \"%s\"," $gitUrl >>manifest
printf "\"gitRef\" : \"%s\"," $gitRef >>manifest
printf "\"contextDir\" : \"%s\"," $contextDir >>manifest
printf "\"manifestPath\" : \"%s\"}\n" $manifestPath >>manifest

