const fs = require('fs');
const path = require('path');

const kernelPath = path.resolve(__dirname, '../kernels/node.js');
const kernelContent = fs.readSync(kernelPath);

var tempDir = null;
var topLevelName = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'top-level name':
      topLevelName = packet;
      break;

    case 'temp directory':
      fs.stat(packet, (error, stats) => {
        if (stats.isDirectory()) {
          tempDir = packet;
        } else {
          console.error(new Error('"' + dir + '" not a directory'));
        }
      });
      break;

    case 'intermediate code':
      if (tempDir === null) {
        console.error(new Error('Temporary directory not defined'));
      }
      if (topLevelName === null) {
        console.error(new Error('Top-level kind name not defined'));
      }

      const parts = JSON.stringify(packet);
      const output = [
        kernelContent,
        'runKernel("' + tempDir + '", ' + parts + ');'
      ];

      send('javascript source code', output.join('\n'));
      break;
  };
};
