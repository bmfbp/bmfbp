#name self.gsh
pipes 8
fork
push 1
push 4
dup 1
exec1st scan
krof 

fork
push 0
push 4
dup 0
push 1
push 3
dup 1
exec check-input
krof 

fork
push 0
push 2
dup 0
push 1
push 6
dup 1
exec assign-pipe-numbers-to-inputs
krof 

fork
push 0
push 1
dup 0
push 1
push 2
dup 1
exec match-ports-to-components
krof 

fork
push 0
push 0
dup 0
push 1
push 1
dup 1
exec mark-directions
krof 

fork
push 0
push 3
dup 0
push 1
push 0
dup 1
exec calc-bounds
krof 

fork
push 0
push 5
dup 0
exec emit-grash
krof 

fork
push 0
push 6
dup 0
push 1
push 7
dup 1
exec assign-pipe-numbers-to-outputs
krof 

fork
push 0
push 7
dup 0
push 1
push 5
dup 1
exec assign-fds
krof 

