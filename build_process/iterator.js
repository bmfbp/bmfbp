const setMain = require('bmfbp');

let state = 'stopped';

setMain((pin, packet, send) => {
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

    default:
      throw new Error(`Unexpected state: ${state}`);
  }
});
