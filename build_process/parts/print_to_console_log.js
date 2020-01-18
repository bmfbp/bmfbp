exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'print':
      console.log((new Date()).toISOString(), ">>", packet);
      break;
  }
};
