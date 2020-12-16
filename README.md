## Example run
% ./build.sh build_process/parts/diagram/helloworld.svg
(lots of output, wait at least 30 seconds)
...
"TOP" outputs on pin "result" : "helloworld"
...

to kill:
^Z
% kill %1

## Example Edit Diagram
  use drawio (e.g. from Finder) to open 
  build_process/parts/diagram/helloworld.drawio (in my case ~/quicklisp/local-projects/bmfbp/build_process/parts/diagram/helloworld.drawio)
  open tab "worldhello" 
  menu File>>Export As...>>SVG (click EXPORT) (change name to "worldhello.svg") (click Save) (if necessary, clisk Replace)
  (note: a and b are swapped)
% ./build.sh build_process/parts/diagram/worldhello.svg
...
"TOP" outputs on pin "result" : "worldhello"
...
^Z
% kill %1


## Instructions

1. Download Docker at `https://www.docker.com/`.
2. Run `./build.sh ${programPath}` to build and run, where `programPath` is the
   path to the SVG file.
3. Repeat step 2 to rebuild after making a change.

## Parts
at present, only 3 parts are available
1. string-join
2. hello
3. world

the parts are in build_process/parts/cl/*.lisp
their manifests are in build_process/parts/*.manifest.json
diagrams are in build_process/diagram/*.drawio
diagrams must be exported to build_process/diagram/*.svg
