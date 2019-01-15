# hs-vsh

## Setup

The project is entirely built on Haskell Stack.

1. Go to https://github.com/commercialhaskell/stack/releases
2. Find the binary for version 1.9.1
3. Run: stack install

## Usage

### DrawIO SVG parser

```
hs-vsh-drawio-to-fb someName < samples/drawio_001.svg
```

The output will match that of `samples/drawio_001.lisp`.
