const path = require('path');
const fs = require('fs');
const kernel = require(path.join(__dirname, 'kernel.js'));

let partKindRefs = {};
let compositeDefs = {};
let rootDir = null;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'composite definition':
console.log('kktet-7387', typeof packet, packet, packet.kindName);
      compositeDefs[packet.kindName] = packet;
      break;

    case 'leaf kind ref':
    case 'composite kind ref':
      partKindRefs[packet.kindName] = packet;
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

    case 'continue':
      if (rootDir === null) {
        console.error(new Error("No root directory provided"));
        return;
      }

      flushKindRefs(send);
      break;
  }
};

const flushKindRefs = async (send) => {
  // Write `compositeDefs` into the same files pointed to in composite kind
  // refs because the kernel takes an array of kind refs and we want to make
  // sure the entrypoint is pointing to a definition file rather than an
  // arrowgram file.
console.log('kktet-7264', compositeDefs);
  await Object.keys(compositeDefs).forEach(async (kindName) => {
    const def = compositeDefs[kindName];
    const kindRef = partKindRefs[kindName];
    const kindIdHash = kernel.getKindIdHash(kindRef);
    const contextPath = path.join(rootDir, kindIdHash);
    const manifestPath = path.join(contextPath, kindRef.manifestPath);

    readJson(manifestPath)
      .then((manifest) => {
        return path.resolve(contextPath, manifest.entrypoint);
      })
      .then((entrypointPath) => {
        fs.writeFile(entrypointPath, def, (err, data) => {
          if (err) {
            Promise.reject(err);
          }
        });
      })
      .catch((err) => {
        console.error(new Error(err));
      });
  });

  send('part kind refs', partKindRefs);

  partKindRefs = {};
  compositeDefs = {};
};

const readJson = async (path) => {
  return new Promise((resolve, reject) => {
    fs.readFile(path, (err, data) => {
      if (err) {
        reject(err);
      }

      try {
        resolve(JSON.parse(data));
      } catch (err) {
        reject(err);
      }
    });
  });
};
