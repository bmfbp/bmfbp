if (!console && typeof console != 'object') {
  const console = {
    log: () => {},
    error: () => {}
  };
}

const esaIfFailedToReturnTrueFalse = (msg) => {
  console.error(`esa-if - expr did not return :true or :false ${msg}`);
};

class Kind {

  constructor() {
    this.kindName = '';
    this.inputPins = [];
    this.outputPins = [];
    this.wires = [];
    this.parts = [];
  }

  installInputPin(name) {
    this.inputPins.push(name.toLowerCase());
  }

  installOutputPin(name) {
    this.outputPins.push(name.toLowerCase());
  }

  installInitiallyFunction(fn) {
    // should be explicitly defined in each class
  }

  installReactFunction(fn) {
    // should be explicitly defined in each class
  }

  installWire(w) {
    this.wires.push(w);
  }

  installPart(name, kind) {
    // TODO: Paul, I'm not sure how we'd link `PartDefinition` here.
    let p = new PartDefinition();
    p.partName = name.toLowerCase();
    p.partKind = kind;
    this.parts.push(p);
  }

  children() {
    return this.parts;
  }

  ensurePartNotDeclared(name) {
    for (let part in this.parts) {
      if (part.partName === name) {
        throw new Error(`part ${name} already declared in ${this.kindName} ${this}`);
      }
    }

    return true;
  }

  ensureValidInputPin(name) {
    for (let pinName in this.inputPins) {
      if (pinName === name) {
        return true;
      }
    }

    throw new Error(`pin ${name} is not an input pin of ${this.kindName} ${this}`);
  }

  ensureValidOutputPin(name) {
    for (let pinName in this.outputPins) {
      if (pinName === name) {
        return true;
      }
    }

    throw new Error(`pin ${name} is not an output pin of ${this.kindName} ${this}`);
  }

  ensureInputPinNotDeclared(name) {
    for (let pinName in this.inputPins) {
      if (pinName === name) {
        throw new Error(`pin /${name}/ is already declared as an input pin of ${this.kindName} ${this}`);
      }
    }

    return true;
  }

  ensureOutputPinNotDeclared(name) {
    for (let pinName in this.outputPins) {
      if (pinName === name) {
        throw new Error(`pin /${name}/ is already declared as an output pin of ${this.kindName} ${this}`);
      }
    }

    return true;
  }

  findChild(name) {
    for (let p in this.parts) {
      if (p.partName === name) {
        return p;
      }
    }

    return null; // no part with given name - can't happen
  }

}

class Source {

  constructor() {
    this.partName = '';
  }

  refersToSelf() {
    return this.partName === 'self';
  }

}

class Destination {

  constructor() {
    this.partName = '';
  }

  refersToSelf() {
    return this.partName === 'self';
  }

}

class Wire {

  constructor() {
    this.index = -1;
    this.sources = [];
    this.destinations = [];
  }

  setIndex(i) {
    this.index = i;
  }

  installSource(partName, pinName) {
    // TODO: Paul, I'm not sure how we'd link `Source` here.
    let s = new Source();
    console.log(`install-source ${partName} ${pinName}`);
    s.partName = partName.toLowerCase();
    s.pinName = pinName.toLowerCase();
    this.sources.push(s);
  }

  installDestination(partName, pinName) {
    // TODO: Paul, I'm not sure how we'd link `Destination` here.
    let d = new Destination();
    d.partName = partName.toLowerCase();
    d.pinName = pinName.toLowerCase();
    this.destinations.push(d);
  }

}

class Node {

  constructor() {
    this.nameInContainer = '';
    this.inputQueue = [];
    this.outputQueue = [];
    this.wires = [];
  }

  clearInputQueue() {
    this.inputQueue = [];
  }

  clearOutputQueue() {
    this.outputQueue = [];
  }

  initially() {
    console.error(`initially on ${this}`);
  }

  displayOutputEventsToConsole() {
    for (let e in this.outputQueue) {
      console.log(`${this.nameInContainer} outputs ${e.pinName} on ${e.data}`);
    }
  }

  flaggedAsBusyP() {
    return this.busyFlag;
  }

  hasNoContainerP() {
    return this.container === null;
  }

  send(e) {
    this.outputQueue.push(e);
  }

  outputEvents() {
    return this.outputQueue;
  }

  dequeueInput() {
    return this.inputQueue.shift();
  }

  inputQueueP() {
    return this.inputQueue === null;
  }

  hasInputsOrOutputsP() {
    return this.inputQueue !== null || this.outputQueue !== null;
  }

  installChild(name, child) {
    // TODO: Paul, I'm not sure how we'd link `PartInstance` here.
    let pdef = new PartInstance;
    pdef.partName = name;
    pdef.partInstance = child;
    this.children.push(pdef);
  }

  enqueueInput(e) {
    this.inputQueue.push(e);
  }

  enqueueOutput(e) {
    this.outputQueue.push(e);
  }

  findWireForSource(partName, pinName) {
    for (let w in this.wires) {
      for (let s in w.sources) {
        if (s.partName === partName && s.pinName === pinName) {
          return w;
        }
      }
    }

    return null; // source not found - can't happen
  }

}

class PartDefinition {

  ensureKindDefined() {
    if (! this.partKind instanceof Kind) {
      console.error(`kind for part /${this.partName}/ is not defined (check if manifest is correct) ${this}`);
    }
  }

}

class Dispatcher {

  constructor()  {
    this.topNode = null;
    this.allParts = [];
  }

  installNode(n) {
    this.allParts.push(n);
  }

  setTopNode(n) {
    this.topNode = n;
  }

  declareFinished() {
    console.log('Dispatcher Finished');
  }

}
