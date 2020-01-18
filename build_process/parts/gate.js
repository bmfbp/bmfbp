const queue = [];
let isOpen = false;
let closeAfterOpen = false;

exports.main = (pin, packet, send) => {
  switch (pin) {
    case 'in':
      if (isOpen) {
        send('out', packet);
      } else {
        queue.push(packet);
      }
      break;

    case 'close after open':
      // The default behavior: As soon as we receive a packet
      // on the 'open' pin we let any future packets pass
      // through. Send a packet to this pin to close the gate
      // after emptying the queue.
      closeAfterOpen = true;
      break;

    case 'open':
      // Open gate on the next tick to preserve ordering.
      setTimeout(() => {
        isOpen = true;

        while (queue.length > 0) {
          let packet = queue.shift();
          send('out', packet, true);
        }

        if (closeAfterOpen) {
          isOpen = false;
        }
      }, 0);
      break;
  }
};
