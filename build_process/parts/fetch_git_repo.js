const child_process = require('child_process');
const fs = require('fs');
const path = require('path');
const tmp = require('tmp');
const kernel = require(path.join(__dirname, 'kernel.js'));

const queue = [];
let sendCache = null;
let rootDir = null;
let tempDir = null;

tmp.dir(function (error, dir, cleanup) {
  if (error) {
    console.error(new Error(error));
  } else {
    tempDir = dir;
    startProcessing();
  }
});

exports.main = (pin, packet, send) => {
  sendCache = send;
  switch (pin) {
    case 'root directory':
      const dir = packet;
      fs.stat(dir, function (error, stats) {
        if (stats.isDirectory()) {
          rootDir = dir;
        } else {
          console.error(new Error(`"${dir}" is not a directory`));
        }
      });
      break;

    case 'kind ref':
      queue.push(packet);
      if (rootDir !== null && tempDir !== null) {
        startProcessing();
      }
      break;
  }
};

const startProcessing = () => {
  if (sendCache) {
    while (queue.length > 0) {
      processKindRef(queue.pop(), sendCache);
    }
  }
};

const processKindRef = (kindRef, send) => {
  const kindIdHash = kernel.getKindIdHash(kindRef);
  const targetDir = path.join(rootDir, kindIdHash);
  const cloneDir = path.join(tempDir, kindIdHash);

  fs.stat(targetDir, function (error, stats) {
    if (!error) {
      // Must be a directory
      if (!stats.isDirectory()) {
        console.error(new Error('Target directory for git repo is a file. Please remove the file: ' + targetDir));
        return;
      }

      // Already there
      send('kind ref', kindRef, true);
      return;
    }

    const cmd = [
      `cd ${tempDir}`,
      `&& git clone ${kindRef.gitUrl} ${kindIdHash}`,
      `&& cd ${kindIdHash}`,
      `&& git checkout ${kindRef.gitRef}`,
      `&& cp -r ${path.resolve(cloneDir, kindRef.contextDir)}/ ${targetDir}/`,
    ].join(' ');

    child_process.exec(cmd, {}, function (error, stdout, stderr) {
      if (error) {
        console.error(new Error(error));
        return;
      }

      send('kind ref', kindRef, true);
    });
  });
};
