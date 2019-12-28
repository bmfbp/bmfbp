exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'in1':
      console.log('in1', packet);
      break;

    case 'in2':
      console.log('in2', packet);
      break;
  }
};

exports.bootstrap = (send, release) => {
  const arrowgram = require('/Users/kenhkan/s/w/arrowgrams/compile_composite.arrowgram.json');
  console.log('mock leaf', arrowgram);
  send('out1', arrowgram);
  setTimeout(release, 1000);
};
