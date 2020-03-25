exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'in':
      let metadata;
      try {
        metadata = JSON.parse(packet.metaData);
      } catch (e) {
        console.error(packet);
        console.error(new Error('Metadata should be a JSON object'));
        return;
      }
      metadata.forEach(function (object) {
        send('out', object);
      });
      break;
    default:
      console.error(new Error('Unknown pin name provided: ' + pin));
  }
};
