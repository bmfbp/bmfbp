let state = 'stopped';

exports.main = (pin, packet, send) => {
  switch (state) {
    case 'stopped':
      switch (pin) {
        case 'start':
          state = 'started';
          break;

        case 'continue':
console.log('kktest-6479', packet);
          break;

        default:
          // No action needed
      }
      break;

    case 'started':
      switch (pin) {
        case 'continue':
console.log('kktest-6480', packet);
          send('get one', true);
          break;

        case 'done':
          //state = 'stopped';
          break;

        default:
          // No action needed
      }
      break;
  }
};
