#name vsh.gsh
pipes 8
fork
outPipe 0
exec1st scan
krof 

fork
inPipe 0
outPipe 7
exec check-input
krof 

fork
inPipe 7
outPipe 1
exec calc-bounds
krof 

fork
inPipe 1
outPipe 2
exec mark-directions
krof 

fork
inPipe 2
outPipe 3
exec match-ports-to-components
krof 

fork
inPipe 3
outPipe 4
exec assign-pipe-numbers-to-inputs
krof 

fork
inPipe 4
outPipe 5
exec assign-pipe-numbers-to-outputs
krof 

fork
inPipe 5
outPipe 6
exec assign-fds
krof 

fork
inPipe 6
exec emit-grash
krof 

