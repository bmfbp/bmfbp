const part = require('_part_');
const tmp = require('tmp');
const child_process = require('child_process');
const path = require('path');
const fs = require('fs');
const isSvg = require('is-svg');

const schematicOutPin = part.outPin('schematic metadata', metadata);
const leafOutPin = part.outPin('leaf metadata', metadata);

let metadata = null;

part.inPin('part metadata', (packet) => {
  metadata = packet();
});

part.inPin('file content', (packet) => {
  if (metadata === null) {
    console.error('No metadata received');
    return;
  }

  let manifestContent;

  try {
    manifestContent = JSON.parse(packet());
  } catch (e) {
    console.error('Incoming packet is not a valid JSON string.');
    return;
  }

  if (! manifestContent.kindType) {
    console.error('Property "kindType" expected');
    return;
  }

  if (manifestContent.kindType === 'schematic') {
    schematicOutPin(metadata);
  } else {
    leafOutPin(metadata);
  }
});
