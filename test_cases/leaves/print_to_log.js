return function (partId, send, release) {
  return function (pin, packet) {
    console.log(packet);
  };
};
