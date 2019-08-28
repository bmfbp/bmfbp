let state = 'stopped';

exports.main = (pin, packet, send) => {
  switch (state) {
    case 'stopped':
      switch (pin) {
        case 'start':
          state = 'started';
          break;

        default:
          // No action needed
      }
      break;

    case 'started':
      switch (pin) {
        case 'continue':
          send('get a part', true);
          break;

        case 'done':
          state = 'stopped';
          break;

        default:
          // No action needed
      }
      break;
  }
};
