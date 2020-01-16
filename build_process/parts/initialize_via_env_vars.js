const tempDir = process.env.TEMP_DIRECTORY;
const topLevelKindRefJson = process.env.TOP_LEVEL_KIND_REF;
const topLevelName = process.env.TOP_LEVEL_NAME;

if (!tempDir) {
  throw new Error('Environment variable "TEMP_DIRECTORY" is not defined.');
}
if (!topLevelKindRefJson) {
  throw new Error('Environment variable "TOP_LEVEL_KIND_REF" is not defined.');
}
if (!topLevelName) {
  throw new Error('Environment variable "TOP_LEVEL_NAME" is not defined.');
}

let topLevelKindRef;

try {
  topLevelKindRef = JSON.parse(topLevelKindRefJson);
} catch (err) {
  console.error(topLevelKindRefJson);
  throw err;
}

exports.main = () => {};

exports.bootstrap = (send, release) => {
  send('temp directory', tempDir);
  send('top-level kind ref', topLevelKindRef);
  send('top-level name', topLevelName);
  release();
};
