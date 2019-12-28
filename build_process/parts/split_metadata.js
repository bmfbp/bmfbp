exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'in':
      let metadata;
      try {
        metadata = JSON.parse(JSON.parse(packet).metaData);
      } catch (e) {
        console.error('Metadata should be a JSON string: ', packet);
        return;
      }
      metadata.forEach(function (object) {
        send('out', object);
      });
      break;
    default:
      console.error('Unknown pin name provided: ' + pin);
  }
};
