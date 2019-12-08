const child_process = require('child_process');
const fs = require('fs');
const os = require('os');
const { sep } = require('path');

// This is assumed to be on PATH.
const program = 'part_compile';

var params = {};

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'name':
      params.name = packet;
      compile(send);
      break;
    case 'facts':
      params.facts = packet;
      compile(send);
      break;
    case 'strings':
      params.strings = packet;
      compile(send);
      break;
  }
};

async function writeTempFile(filePath, content) {
  return new Promise((resolve, reject) => {
    fs.writeFile(filePath, content, (err) => {
      if (err) {
        console.error(filePath, err);
        reject();
        return;
      }

      resolve(filePath);
    });
  });
}

function compile(send) {
  compile2(send).catch(err => {
    if (err) {
      console.error(err);
      return;
    }
  });
}

async function compile2(send) {
  if (!params.name || !params.facts || !params.strings) {
    return;
  }
  const name = params.name;
  const facts = params.facts;
  const strings = params.strings;

  await fs.mkdtemp(`${os.tmpdir()}${sep}`, async (err, dir) => {
    if (err) {
      console.error(dir, err);
      return;
    }

    const factPath = await writeTempFile(dir + "facts", facts);
    const stringPath = await writeTempFile(dir + "strings" , strings);
    const command = [program, name, stringPath, factPath].join(' ');

    child_process.exec(command, function(err, stdout, stderr) {
      console.error(stderr);
      if (err) {
        console.error(command, err);
        return;
      }

      send('graph as json', stdout);
    });
  });

  // Clean up
  params = {};
}
