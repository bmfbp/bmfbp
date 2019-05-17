return function (partId, send, release) {
  return function (pin, packet) {
    send(partId, 0, packet + 1);
  };
};
