# Start with Haskell toolchain on Debian.
FROM haskell:8.4.4

# Set working directory.
WORKDIR /app
# Expose port for HTTP server.
EXPOSE 8080

# Install appropriate stack in a preflight run.
COPY preflight /app/preflight
RUN cd /app/preflight && stack install

# Install netcat, used as a webserver.
RUN apt-get update && apt-get install -y netcat

# Copy app over and install.
COPY . /app
RUN cp /app/bash-parts/* /usr/local/bin && \
    cd /app/hs-parts && stack install && \
    cp ~/.local/bin/* /usr/local/bin

# Run entrypoint.
CMD /app/run_network
