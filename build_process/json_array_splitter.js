const part = require('_part_');

const objectsOutPin = part.outPin('objects');

part.inPin('json', (packet) => {
  packet().forEach(function (object) {
    objectsOutPin(object);
  });
});
