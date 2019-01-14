# Usage

1. Get [Docker](https://www.docker.com/).
2. Run `docker build .` in this directory. You should see a bunch of log output ending in a line like `Successfully built a0f7c9cb77b6`. The `a0f7c9cb77b6` is the image ID and will be different every time you build.
3. Run `docker run -d -p 8080:8080 <image-id>` where `<image-id>` is the image ID from step #2. You will see something like `a5c5dcaec829634847dfe5f8c5f637569544792ca1705f8a80c9b0f3826f75a8` as its only output. This is the container ID and will be different every time you run the image.
4. Send an HTTP request with `curl -v http://localhost:8080` or `curl -d body -v http://localhost:8080`. The former sends a GET request and the latter sends a POST request. This trivial web service does nothing to GET requests and sends back the string "redacted" (as if it redacts whatever body the client sends to it) for POST requests.
5. When you are done, remember to remove the container by running `docker kill <container-id>` where `<container-id>` is from step #3.

# Caveats

- This example doesn't leverage vsh. It simply uses a UNIX pipeline with a named pipe to close the loop. It is bmfbp in spirit though.
- Currently the webserver doesn't terminate the connection. You have to quit from the client side by doing Ctrl-C or something similar.
- We use netcat to simulate a webserver. Everything is blocking, so until the current connection is complete, no new connection can be accepted.
- There is a while-loop in `run_network` (basically the bmfbp "network" for this example) because netcat exits upon a completed connection. In a sense this example is closer to FBP than bmfbp.

# Detail explanation

There are four parts to this network.

1. netcat-server
2. http-receive
3. redact
4. http-send

netcat-server is located in `bash-parts/netcat-server`. It simply spins up an HTTP server using netcat on port 8080.

http-receive takes the output of netcat-server, which is just an HTTP request in plain text as specified in the HTTP specification, and prints to stdout pairs, separated by newlines. The name and value of the pairs are separated by a tab character to allow visible characters in the value. Consider this just a Tab-Separated Value file restricted to pairs.

The name is either an HTTP header name as sent by the client or the string "Body". The value is either an HTTP header value or the body message if the request is a POST.

redact simply substitutes the body message, if any, with the string "redacted".

http-send prints the body message in proper HTTP response format. Its output is piped to a named pipe, which pipes it back to netcat-server, which forwards the response to the client.

There are some examples under `sample/`. The number after the dash signifies after which step the content is produced. For example, `sample/sample1-2.txt` contains the content output by http-receive. All the files with the same prefix before the dash belong to the same run throughout the network.
