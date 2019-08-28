const child_process = require('child_process');
const fs = require('fs');
const temp = require('../lib/temp');

// This is assumed to be on PATH.
const program = 'part_compile';

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'diagram':
      temp.file((inputFilePath) => {
        fs.writeFile(inputFilePath, packet, (err) => {
          if (err) {
            console.error(err);
            return;
          }

          const command = [program, inputFilePath].join(' ');
          child_process.exec(command, function(err, stdout, stderr) {
            if (err) {
              console.error(err);
              return;
            }

            send('graph as json', stdout);
          });
        });
      });
      break;
  }
};
