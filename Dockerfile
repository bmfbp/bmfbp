# Instructions:
#
# 1. Download Docker at `https://www.docker.com/`
#
# 2. After installation, make sure your Docker engine is set to allow for at least 4 GB of memory.
#
# 3. Run `docker build . --tag arrowgrams:0.1` in the directory that this file is in. You will see the following at the end:
#
# 4. Run the container: `docker run --name=arrowgrams -v (pwd):/root/quicklisp/local-projects/bmfbp -p 8000:8000 arrowgrams:0.1`

FROM ubuntu:18.04

# Install essentials
RUN apt-get update && \
  apt-get install -y git && \
  mkdir -p /root/quicklisp/local-projects

# Clone Paul Tarvydas' tools
RUN cd /root/quicklisp/local-projects && \
  git clone https://github.com/guitarvydas/cl-event-passing && \
  git clone https://github.com/guitarvydas/cl-holm-prolog && \
  git clone https://github.com/guitarvydas/loops && \
  git clone https://github.com/guitarvydas/cl-peg && \
  git clone https://github.com/guitarvydas/sl.git

# Set up system and install dependencies
RUN apt-get update && \
  apt-get install -y make && \
  apt-get install -y wget && \
  apt-get install -y sbcl && \
  mkdir -p /root/quicklisp/local-projects && \
  mkdir -p /root/bin && \
  export PATH=/root/.local/bin:/usr/local/bin:/root/.local/bin:$PATH

# Install Haskell stack
RUN wget -qO- https://get.haskellstack.org/ | sh

# Set up quicklisp
RUN wget https://beta.quicklisp.org/quicklisp.lisp && \
  sbcl --load quicklisp.lisp \
    --eval "(quicklisp-quickstart:install)" \
    --quit && \
  echo "#-quicklisp" >> /root/.sbclrc && \
  echo "(let ((quicklisp-init (merge-pathnames \"quicklisp/setup.lisp\" (user-homedir-pathname)))) (when (probe-file quicklisp-init) (load quicklisp-init)))" >> /root/.sbclrc

# Install elm
RUN wget https://github.com/elm/compiler/releases/download/0.19.0/binary-for-linux-64-bit.gz && \
  gunzip binary-for-linux-64-bit.gz && \
  chmod +x binary-for-linux-64-bit && \
  mv binary-for-linux-64-bit /usr/local/bin/elm

# Clone and set up Arrowgrams, then remove the repo. This is only to save set-up time at run-time.
RUN cd /root/quicklisp/local-projects && \
  git clone https://github.com/bmfbp/bmfbp && \
  cd /root/quicklisp/local-projects/bmfbp && \
  git checkout pt-20200106 && \
  make && \
  cd /root/quicklisp/local-projects/bmfbp/editor && \
  make && \
  cd /root && \
  rm -rf /root/quicklisp/local-projects/bmfbp

# Make Arrowgrams, refresh quicklisp, and run hello-world. This is what you would run manually.
CMD cd /root/quicklisp/local-projects/bmfbp && \
  make && \
  sbcl --eval "(quicklisp:register-local-projects)" --quit && \
  sbcl --eval "(quicklisp:quickload :arrowgrams/build)" --eval "(arrowgrams/build::helloworld)" --quit && \
  cd /root/quicklisp/local-projects/bmfbp/editor && \
  elm reactor
