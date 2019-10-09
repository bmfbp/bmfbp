const tmp = require('tmp');
const child_process = require('child_process');
const path = require('path');
const fs = require('fs');
const isSvg = require('is-svg');

let metadata = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'part metadata':
      metadata = packet;
      break;

    case 'file content':
      if (metadata === null) {
        console.error('No metadata received');
        return;
      }

      let manifestContent;

      try {
        manifestContent = JSON.parse(packet);
      } catch (e) {
        console.error('Incoming packet is not a valid JSON string.');
        return;
      }

      if (! manifestContent.kindType) {
        console.error('Property "kindType" expected');
        return;
      }

      if (manifestContent.kindType === 'schematic') {
        send('schematic metadata', metadata);
      } else {
        send('leaf metadata', metadata);
      }
      break;
  }
};
