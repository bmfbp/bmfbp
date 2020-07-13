#!/bin/bash
nnnn=$1
topLeftx=$2
topLefty=$3
bottomRightx=$4
bottomRighty=$5
kindName=$6
width=`expr $bottomRightx - $topLeftx`
height=`expr $bottomRighty - $topLefty`
halfWidth=`expr $width / 2`
halfHeight=`expr $height / 2`
printf "\n\
ellipse(ellipse_$nnnn).\n\
eltype(ellipse_$nnnn,box).\n\
geometry_center_x(ellipse_$nnnn,`expr $topLeftx + \( $halfWidth \) `).\n\
geometry_center_y(ellipse_$nnnn,`expr $topLefty + \( $halfHeight \) `).\n\
geometry_w(ellipse_$nnnn,width).\n\
geometry_h(ellipse_$nnnn,height).\n\
text(Text_$nnnn,$kindName).\n\
geometry_center_x(kindText_$nnnn, `expr $topLeftx +  $halfWidth `).\n\
geometry_$top_y(kindText_$nnnn, $topLefty).\n\
geometry_w(kindText_$nnnn, $width).\n\
geometry_h(kindText_$nnnn, $height).\n\
"
