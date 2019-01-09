FROM haskell:8.4.4

WORKDIR /app

COPY preflight /app/preflight
RUN cd /app/preflight && stack install
COPY . /app

RUN cp /app/bash-parts/* /usr/local/bin && \
    cd /app/hs-parts && stack install && \
    cp ~/.local/bin/* /usr/local/bin
