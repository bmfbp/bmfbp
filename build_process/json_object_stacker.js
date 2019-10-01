const part = require('_part_');

const noMoreOutPin = part.outPin('no more');
const partMetadataOutPin = part.outPin('part metadata'));

const stack = [];

part.inPin('push object', (packet) => {
  stack.push(packet);
});

part.inPin('get a part', (packet) => {
  if (stack.length === 0) {
    noMoreOutPin(true);
  } else {
    partMetadataOutPin(stack.pop());
  }
});
