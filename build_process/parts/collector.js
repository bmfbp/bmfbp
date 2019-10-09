var parts = {};

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'composite':
      parts[part.name] = packet;
      break;

    case 'leaf':
      parts[part.kindName] = packet;
      break;

    case 'done':
      send('intermediate code', parts);
      parts = [];
      break;
  }
};
