const fs = require('fs');
const path = require('path');
const kernelPath = path.join(__dirname, 'kernel.js');

var rootDir = null;
var topLevelName = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'top-level name':
      topLevelName = packet;
      break;

    case 'root directory':
      fs.stat(packet, (error, stats) => {
        if (stats.isDirectory()) {
          rootDir = packet;
        } else {
          console.error(new Error(`"${dir}" not a directory`));
        }
      });
      break;

    case 'part kind refs':
      if (rootDir === null) {
        console.error(new Error('Temporary directory not defined'));
      }
      if (topLevelName === null) {
        console.error(new Error('Top-level kind name not defined'));
      }

      const parts = JSON.stringify(packet);
      const output = `require("${kernelPath}").runKernel("${rootDir}", ${parts}, "${topLevelName}");`;

      send('nodejs source code', output);

      rootDir = null;
      topLevelName = null;
      break;
  };
};
