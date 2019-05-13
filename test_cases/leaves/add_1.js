return (partId, send, release) => {
  return (pin, packet) => {
    send(partId, 0, packet + 1);
  };
};
