const stack = [];
let toRelease = false;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'push one':
console.log('kktest-6483');
      stack.push(packet);

      // Given a stream of incoming objects, only trigger release of the first
      // one.
      if (!toRelease) {
        toRelease = true;
        setTimeout(() => {
          releaseOneFromStack(send);
          toRelease = false;
        }, 0);
      }
      break;

    case 'get one':
console.log('kktest-6482');
      releaseOneFromStack(send);
      break;
  }
};

const releaseOneFromStack = (send) => {
console.log('kktest-6481', stack.length);
  if (stack.length > 0) {
    send('one object', stack.pop(), true);
  }

  if (stack.length === 0) {
    send('no more', true);
  }
}
