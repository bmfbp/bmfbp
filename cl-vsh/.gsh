#name echo-cat.gsh
pipes 1
fork
push 1
push 0
dup 1
exec echo hello
krof 

fork
push 0
push 0
dup 0
exec cat -
krof 

