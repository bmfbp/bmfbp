exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'print':
      console.log("kktest-0000");
      console.log((new Date()).toISOString(), ">>", packet);
      break;
  }
};
