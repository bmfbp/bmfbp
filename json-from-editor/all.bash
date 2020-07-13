#!/bin/bash
./new.bash
./polyline.bash 10 750 228 890 225 c \'\'
./polyline.bash  9 438 340 700 277 s b
./polyline.bash  8 442 121 695 176 s a
./polyline.bash  7 194 229 387 289 \'\' start
./polyline.bash  6 194 228 391 173 \'\' \'\'
./ellipse.bash 5 893 176 1043 276 result
./ellipse.bash 4 47 178 197 278 start
./rect.bash 3 654 175 754 275 'string-join' 'https://github.com/bmfbp/bmfbp.git' 'master' 'build_process/' 'lispparts/string-join.lisp'
./rect.bash 2 342 289 442 389 'world' 'https://github.com/bmfbp/bmfbp.git' 'master' 'build_process/' 'lispparts/string-join.lisp'
./rect.bash 1 345 75 445 175 'hello' 'https://github.com/bmfbp/bmfbp.git' 'master' 'build_process/' 'lispparts/string-join.lisp'
