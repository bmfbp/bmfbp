const part = require('_part_');

var composites = [];
var leaves = [];

const intermediateCodeOutPin = part.outPin('intermediate code');

part.inPin('composite', (packet) => {
  composites.push(packet);
});

part.inPin('leaf', (packet) => {
  leaves.push(packet);
});

part.inPin('done', (packet) => {
  intermediateCodeOutPin({
    composites: composites,
    leaves: leaves
  });
  composites = [];
  leaves = [];
});
