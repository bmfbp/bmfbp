return function (partId, send, release) {
  return function (pin, packet) {
    switch (pin) {
      case 'json':
        packet().forEach(function (object) {
          send(partId, 'objects', object);
        });
        break;
    }
  };
};
