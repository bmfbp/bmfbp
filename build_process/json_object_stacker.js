return function (partId, send, release) {
  const stack = [];

  return function (pin, packet) {
    switch (pin) {
      case 'push object':
        stack.push(packet);
        break;

      case 'get a part':
        if (stack.length === 0) {
          send(partId, 'no more', true);
        } else {
          send(partId, 'part metadata', stack.pop());
        }
        break;
    }
  };
};
