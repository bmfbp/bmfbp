'use strict';

const fs = require('fs');
const path = require('path');
const ncp = require('ncp').ncp;
const commandExistsSync = require('command-exists').sync;
const util = require('util');
const exec = util.promisify(require('child_process').exec);
const del = require('del');
const Joi = require('@hapi/joi');
const kernel = require(path.resolve(__dirname, 'kernel'));

const compilerCmd = 'jsbmfbp3';

if (!commandExistsSync(compilerCmd)) {
  throw new Error(`Compiler command "${compilerCmd}" is not found.`);
}

const makeKindRef = (kindName, gitUrl, gitRef, contextDir, manifestPath) => {
  return {
    contextDir: contextDir,
    manifestPath: manifestPath,
    kindName: kindName,
    gitRef: gitRef,
    gitUrl: gitUrl
  };
};

const setupKindsLocally = async (pathToLocalGitRepo, rootDir, kindRefs, options) => {
  return Object.keys(kindRefs).reduce(((promise, kindName) => {
    return promise.then(async () => {
      return setupKindLocally(pathToLocalGitRepo, rootDir, kindRefs[kindName], options);
    });
  }), Promise.resolve());
};

const setupKindLocally = async (pathToLocalGitRepo, rootDir, kindRef, options = {}) => {
  const toCompileComposites = options.toCompileComposites || false;
  const kindIdHash = kernel.getKindIdHash(kindRef);
  const localKindPath = path.join(rootDir, kindIdHash);
  const srcDir = path.join(pathToLocalGitRepo, kindRef.contextDir);

  console.log(`Deleting existing local kind at "${localKindPath}"`);
  await del([localKindPath], { force: true });

  console.log(`Copying over the kind from "${srcDir}" to "${localKindPath}"`);
  await util.promisify(ncp)(srcDir, localKindPath, {});

  const manifestPath = path.join(localKindPath, kindRef.manifestPath);
  const manifest = JSON.parse(fs.readFileSync(manifestPath));
  const entrypointPath = path.resolve(path.dirname(manifestPath), manifest.entrypoint);
  const isComposite = manifest.kindType === 'composite';

  console.log(`Is "${kindRef.kindName}" a composite? ${isComposite}`);
  if (toCompileComposites && isComposite) {
    console.log(`It is a composite. Compiling it right now using "${compilerCmd}"`);
    const { stdout, stderr } = await exec(`${compilerCmd} ${entrypointPath}`);
    console.log(`Compilation is complete. Writing to "${entrypointPath}".`);
    fs.writeFileSync(entrypointPath, stdout);
  }

  console.log(`Setting up "${kindRef.kindName}" is complete.`);
};

const partDefinitionSchema = Joi.object({
  inCount: Joi.number().integer().required(),
  inMap: Joi.object().required(),
  inPins: Joi.array().items(Joi.array().items(Joi.number().integer())).required(),
  kindName: Joi.string().allow('').required(),
  outCount: Joi.number().integer().required(),
  outMap: Joi.object().required(),
  outPins: Joi.array().items(Joi.array().items(Joi.number().integer())).required(),
  partName: Joi.string().required().allow('').required()
});

const compositeDefinitionSchema = Joi.object({
  kindName: Joi.string().required(),
  metaData: Joi.string().required(),
  parts: Joi.array().items(partDefinitionSchema).required(),
  self: partDefinitionSchema.required(),
  wireCount: Joi.number().integer().required()
});

const kindRefSchema = Joi.object({
  contextDir: Joi.string().required(),
  manifestPath: Joi.string().required(),
  kindName: Joi.string().required(),
  gitRef: Joi.string().required(),
  gitUrl: Joi.string().required()
});

const manifestSchema = Joi.object({
  entrypoint: Joi.string(),
  kindType: Joi.any().valid('composite', 'leaf'),
  platform: Joi.any().valid('nodejs'),
  inPins: Joi.array().items(Joi.string()),
  outPins: Joi.array().items(Joi.string())
});

const preflightCheck = (rootDir, kindRefs, topLevelKindName) => {
  console.log(`Preflight check at "${rootDir}" with top-level kind name of "${topLevelKindName}" and kind refs:`, kindRefs);

  if (!fs.existsSync(rootDir) || !fs.statSync(rootDir).isDirectory()) {
    throw new Error(`Root directory does not exist at "${rootDir}"`);
  }

  if (kindRefs[topLevelKindName] === undefined) {
    throw new Error(`Top level kind name "${topLevelKindName}" not found`);
  }

  Object.keys(kindRefs).forEach((key) => {
    console.log(`Checking kind "${key}"`);
    const kindRef = kindRefs[key];

    console.log('Checking kind ref:', kindRef);
    Joi.attempt(kindRef, kindRefSchema);

    const manifest = kernel.getManifestFromKindRef(rootDir, kindRef);
    console.log('Checking manifest:', manifest);

    checkKindManifest(rootDir, kindRef, manifest);

    const entrypointPath = kernel.getAbsPath(rootDir, kindRef, manifest.entrypoint);
    const entrypoint = require(entrypointPath);

    switch (manifest.kindType) {
      case 'composite':
        console.log('Checking composite entrypoint:', entrypoint);
        const compositeValidationResult = compositeDefinitionSchema.validate(entrypoint);
        if (compositeValidationResult.error) {
          console.error(compositeValidationResult);
          throw new Error('entrypoint fails validation');
        }
        break;

      case 'leaf':
        console.log('Checking leaf entrypoint:', entrypoint);

        if (typeof entrypoint.main !== 'function') {
          throw new Error('entrypoint.main must be a function and is not.');
        }
        break;
    }
  });
};

const checkKindManifest = (rootDir, kindRef, manifest) => {
  console.log('Checking kind manifest:', manifest);
  Joi.attempt(manifest, manifestSchema);

  const entrypointPath = kernel.getAbsPath(rootDir, kindRef, manifest.entrypoint);
  console.log('Checking entrypoint:', entrypointPath);
  if (!fs.existsSync(entrypointPath) || !fs.statSync(entrypointPath).isFile()) {
    throw new Error(`Entrypoint "${entrypointPath}" does not exist`);
  }
};

exports.preflightCheck = preflightCheck;
exports.makeKindRef = makeKindRef;
exports.setupKindsLocally = setupKindsLocally;
