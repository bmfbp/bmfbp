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

      sendKindRef(packet, send).catch((error) => console.error(new Error(error)));
      break;
  }
};

const sendKindRef = async (kindRef, send) => {
  const kindIdHash = kernel.getKindIdHash(kindRef);
  const repoDir = path.join(rootDir, kindIdHash);

  const repoDirStats = await getFileStats(repoDir);
  if (!repoDirStats.isDirectory()) {
    console.error(new Error(`Repo path "${repoDir}" is not a directory.`));
    return;
  }

  const manifestFilePath = path.join(repoDir, kindRef.manifestPath);
  const manifestFileStats = await getFileStats(manifestFilePath);
  if (!manifestFileStats.isFile()) {
    console.error(new Error(`No manifest file found at "${manifestFilePath}".`));
    return;
  }

  const manifest = await readJson(manifestFilePath);
  const entrypointPath = path.resolve(repoDir, manifest.entrypoint);
  const arrowgram = await readJson(entrypointPath);

  send('kind ref', kindRef);
  send('arrowgram', arrowgram, true);
};

const getFileStats = async (path) => {
  return new Promise((resolve, reject) => {
    fs.stat(path, function (error, stats) {
      if (error) {
        reject(error);
        return;
      }

      resolve(stats);
    });
  });
};

const readJson = async (path) => {
  return new Promise((resolve, reject) => {
    fs.readFile(path, (error, data) => {
      if (error) {
        reject(error);
        return;
      }

      try {
        resolve(JSON.parse(data));
      } catch (err) {
        reject(err);
      }
    });
  });
};
