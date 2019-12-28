# The bmfbp kernel

## Requirements

The example schematic used must satisfy:

1.  Part(s) that is a "driver" Part that can trigger the flow
2.  Multiple Parts connected to one downstream Part on one Pin
3.  Multiple Parts connected to one downstream Part on multiple Pins
4.  One Part connected to multiple downstream Parts on one Pin
      a. The first downstream Part modifies the incoming packet. The
         second downstream Part should not be impacted.
      b. The downstream Parts share the same wire to honor the
         "at-the-same-time" semantic. See
         https://github.com/bmfbp/bmfbp/pull/11#discussion_r252028600.
5.  One Part connected to multiple downstream Parts on multiple Pins
6.  Multiple instances of the same Kind are used within one Composite
7.  Use Composites
8.  Multiple instances of the same Kind are used in multiple composites
9.  A source of a Composite is connected directly to a sink of that same
    Composite.
10. A Sink of a Composite that is not connected
11. A Source of a Composite that is not connected
12. An output pin of a Leaf Part that is not connected

## API

The kernel module exports one function:

`run(rootDir, kinds, topLevelKindName)`

where

- `rootDir` is the directory containing all the information about the kinds.
  The kernel locates the definition file using:
  `${rootDir}/${sha256(${repo}-${ref})/${dir}/${file}`, where all the variables
  except for `rootDir` are extracted from the leaf definition (see below).
- `kinds` is an object whose keys are the kind names and whose values are the
  reference objects.
- `topLevelKindName` is the kind name to start running with.

### References

The kernel only takes these. It then resolves each reference to a manifest file
specified below.

This is an example of a reference object.

```
{
  "contextDir": "build_process/",
  "manifestPath": "get_file_content_in_repo.json",
  "kindName": "get file content in repo",
  "gitRef": "master",
  "gitUrl": "https://github.com/bmfbp/bmfbp.git"
}
```

### Leaves

A manifest file for leaves looks something like:

```
{
  "entrypoint": "./get_file_content_in_repo.js",
  "kindType": "leaf",
  "platform": "nodejs",
  "inPins": [
    "git repo metadata",
    "temp directory"
  ],
  "outPins": [
    "metadata",
    "file content"
  ]
}
```

For leaves, the entrypoint file must export at least a `main` function for the
system to call into. It can optionally include a `bootstrap` function that
would be called after system initialization. A common use case is to send the
initial messages to start the system.

An example in Node.js:

```
exports.bootstrap = (send, release) => {
  // Send a message and start the system after 1 second.
  send('someOutPin', 'a message');
  setTimeout(release, 1000);
};

exports.main = (pin, packet, send) => {
  // Received a message `packet` on `pin`.
  send('someOtherPin', 'another message');
};
```

### Composites

A manifest file for composites looks something like:

```
{
  "entrypoint": "./mock.json",
  "kindType": "schematic",
  "platform": "nodejs",
  "inPins": [],
  "outPins": []
}
```

This is an example for a composite definition file pointed to in `entrypoint`
above.

```
{
  "partName": "ID374",
  "wireCount": 4,
  "self": {
    "kindName": "pass_and_add",
    "inCount": 3,
    "outCount": 1,
    "inPins": [[0], [1], [2]],
    "outPins": [[0, 3]]
  },
  "parts": [
    {
      "kindName": "add_1",
      "inCount": 1,
      "outCount": 1,
      "inPins": [[1]],
      "outPins": [[3]],
    }
  ]
}
```
