exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'json':
      packet.forEach(function (object) {
        send('objects', object);
      });
      break;
  }
};
