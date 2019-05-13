return (partId, send, release) => {
  var count = 0;

  const outputOne = () => {
    send(partId, 0, 1);
    release(partId);

    if (++count < 3) {
      setTimeout(outputOne, 1000);
    }
  };

  outputOne();

  return function (pin, packet) {};
};
