const part = require('_part_');

const getAPartOutPin = part.outPin('get a part');

var state = 'stopped';

part.inPin('start', (packet) => {
  state = 'started';
});

part.inPin('continue', (packet) => {
  if (state === 'started') {
    getAPartOutPin(true);
  }
});

part.inPin('done', (packet) => {
  state = 'stopped';
});
