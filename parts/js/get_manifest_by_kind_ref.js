const path = require('path');
const fs = require('fs');
const crypto = require('crypto');
const kernel = require(path.join(__dirname, 'kernel.js'));

let rootDir = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'root directory':
      const dir = packet;
      fs.stat(dir, function (error, stats) {
        if (! stats.isDirectory()) {
          console.error(new Error(`"${dir}" is not a directory.`));
          return;
        }

        rootDir = dir;
      });
      break;

    case 'kind ref':
      if (rootDir === null) {
        console.error(new Error('Temporary directory not defined'));
        return;
      }

      const kindRef = packet;
      const kindIdHash = kernel.getKindIdHash(kindRef);
      const repoDir = path.join(rootDir, kindIdHash);

      fs.stat(repoDir, function (error, stats) {
        if (error) {
          console.error(new Error(error));
          return;
        } else if (! stats.isDirectory()) {
          console.error(new Error(`"${repoDir}" is not a directory.`));
          return;
        }

        const filePath = path.join(repoDir, kindRef.manifestPath);

        fs.stat(filePath, function (error, stats) {
          if (error) {
            console.error(new Error(error));
            return;
          }

          if (!stats.isFile()) {
            console.error(new Error(`No file found at "${filePath}".`));
            return;
          }

          fs.readFile(filePath, function (error, data) {
            if (error) {
              console.error(new Error(error));
              return;
            }

            try {
              manifest = JSON.parse(data);
            } catch (e) {
              console.error(new Error('Incoming packet is not a valid JSON string.'));
              return;
            }

            send('manifest', manifest, true);
          });
        });
      });
      break;
  }
};
