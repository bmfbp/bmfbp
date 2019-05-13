return (partId, send, release) => {
  let packetCount = 0;

  return (pin, packet) => {
    if (++packetCount % 3 === 0) {
      send(partId, 1, packet);
    }

    send(partId, 0, packet);
  };
};
