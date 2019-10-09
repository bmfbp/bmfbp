const child_process = require('child_process');

// This is assumed to be on PATH.
const program = 'part_split';

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'svg content':
      const command = [program, packet].join(' ');
      child_process.exec(command, function(err, stdout, stderr) {
        if (err) {
          console.error(err);
          return;
        }

        // Use output stream 0 for the diagram.
        send('diagram', stdout);
        // Use output stream 1 for the metadata.
        const metadata = JSON.parse(stderr);
        // Workaround for extraneous brackets from `part_split`.
        send('metadata as json array', metadata[0]);
      });
      break;
  }
};
