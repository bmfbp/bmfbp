const part = require('_part_');
const path = require('path');
const fs = require('fs');
const crypto = require('crypto');

const metadataOutPin = part.outPin('metadata');
const fileContentOutPin = part.outPin('file content');

let tempDir = null;

part.inPin('temp directory', (packet) => {
  const dir = packet();
  fs.stat(dir, function (error, stats) {
    if (! stats.isDirectory()) {
      console.error(new Error('"' + dir + '" not a directory'));
      return;
    }

    tempDir = dir;
  });
});

part.inPin('git repo metadata', (packet) => {
  if (tempDir === null) {
    console.error(new Error('Temporary directory not defiend'));
    return;
  }

  const metadata = packet();
  const repoIdOnFilesystem = [metadata.repo, metadata.ref].join('-');
  const repoIdHash = crypto.createHash('sha256').update(repoIdOnFilesystem).digest('hex');
  const repoDir = path.join(tempDir, repoIdHash);

  fs.stat(repoDir, function (error, stats) {
    if (error) {
      console.error(error);
      return;
    } else if (! stats.isDirectory()) {
      console.error(new Error(repoDir + ' not a directory'));
      return;
    }

    const filePath = path.join(repoDir, metadata.dir, metadata.file);

    fs.stat(filePath, function (error, stats) {
      if (error) {
        console.error(error);
        return;
      }

      if (!stats.isFile()) {
        console.error(new Error('No file found at ' + filePath));
        return;
      }

      fs.readFile(filePath, function (error, data) {
        if (error) {
          console.error(error);
          return;
        }

        metadataOutPin(metadata);
        fileContentOutPin(data);
      });
    });
  });
});
