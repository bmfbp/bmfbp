const part = require('_part_');
const child_process = require('child_process');

const diagramOutPin = part.outPin('diagram');
const metadataAsJsonArrayOutPin = part.outPin('metadata as json array');

const command = 'split_diagram';

part.inPin('svg content', (packet) => {
  child_process.exec(command, function(err, stdout, stderr) {
    if (err) {
      console.error(err);
      return;
    }

    // Use output stream 0.
    diagramOutPin(stdout);
    // Use output stream 1.
    metadataAsJsonArrayOutPin(stderr);
  });
});
