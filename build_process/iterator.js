return function (partId, send, release) {
  var state = 'stopped';

  return function (pin, packet) {
    switch (pin) {
      case 'start':
        state = 'started';
        break;

      case 'continue':
        if (state === 'started') {
          send(partId, 'get a part', true);
        }
        break;

      case 'done':
        state = 'stopped';
        break;
    }
  };
};
