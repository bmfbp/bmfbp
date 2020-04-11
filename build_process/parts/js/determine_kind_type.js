const tmp = require('tmp');
const child_process = require('child_process');
const path = require('path');

let manifest = null;
let kindRef = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'manifest':
      manifest = packet;
      determineKindType(send);
      break;

    case 'kind ref':
      kindRef = packet;
      determineKindType(send);
      break;
  }
};

const determineKindType = (send) => {
  if (manifest === null || kindRef === null) {
    return;
  }

  if (! manifest.kindType) {
    console.error(new Error('Property "kindType" expected'));
    return;
  }

  if (manifest.kindType === 'composite') {
    send('composite kind ref', kindRef);
  } else {
    send('leaf kind ref', kindRef);
  }

  manifest = null;
  kindRef = null;
};
