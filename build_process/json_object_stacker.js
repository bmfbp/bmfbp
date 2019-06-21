const setMain = require('bmfbp');

const stack = [];

setMain((pin, packet, send) => {
  switch (pin) {
    case 'push object':
      stack.push(packet);
      break;

    case 'get a part':
      if (stack.length === 0) {
        send('no more', true);
      } else {
        send('part metadata', stack.pop());
      }
      break;

    default:
      throw new Error(`Unexpected pin: ${pin}`);
  }
});
