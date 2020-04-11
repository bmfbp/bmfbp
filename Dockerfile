FROM ubuntu:18.04

ENV project_root "/root"

# Install essential dependencies
RUN apt-get update && \
  apt-get install -y git && \
  apt-get install -y make && \
  apt-get install -y wget && \
  apt-get install -y sbcl && \
  apt-get install -y python && \
  mkdir -p /root/quicklisp/local-projects && \
  mkdir -p /root/bin && \
  export PATH=/root/.local/bin:/usr/local/bin:/root/.local/bin:$PATH

# Clone Paul Tarvydas' tools
RUN cd /root/quicklisp/local-projects && \
  git clone https://github.com/guitarvydas/cl-event-passing && \
  git clone https://github.com/guitarvydas/cl-holm-prolog && \
  git clone https://github.com/guitarvydas/loops && \
  git clone https://github.com/guitarvydas/cl-peg && \
  git clone https://github.com/guitarvydas/sl.git

ARG build_mode
ARG version

# Install Haskell stack
RUN [ "$build_mode" = "full" ] && \
  wget -qO- https://get.haskellstack.org/ | sh || \
  echo

# Set up quicklisp
RUN wget https://beta.quicklisp.org/quicklisp.lisp && \
  sbcl --load quicklisp.lisp \
    --eval "(quicklisp-quickstart:install)" \
    --quit && \
  echo "#-quicklisp" >> /root/.sbclrc && \
  echo "(let ((quicklisp-init (merge-pathnames \"quicklisp/setup.lisp\" (user-homedir-pathname)))) (when (probe-file quicklisp-init) (load quicklisp-init)))" >> /root/.sbclrc

# Install elm
RUN [ "$build_mode" = "full" ] && \
  wget https://github.com/elm/compiler/releases/download/0.19.0/binary-for-linux-64-bit.gz && \
  gunzip binary-for-linux-64-bit.gz && \
  chmod +x binary-for-linux-64-bit && \
  mv binary-for-linux-64-bit /usr/local/bin/elm || \
  echo

# Clone Arrowgrams
RUN cd /root/quicklisp/local-projects && \
  git clone https://github.com/bmfbp/bmfbp && \
  cd /root/quicklisp/local-projects/bmfbp && \
  git checkout pt-20200106

# Build binaries
RUN [ "$build_mode" = "full" ] && \
  cd /root/quicklisp/local-projects/bmfbp/hs-vsh && \
  make && \
  cd /root/quicklisp/local-projects/bmfbp/editor && \
  make || \
  echo

# Use pre-built binaries if available
RUN [ "$build_mode" != "full" ] && \
  [ -d "/root/quicklisp/local-projects/bmfbp/builds/${version}" ] && \
  cp "/root/quicklisp/local-projects/bmfbp/builds/${version}"/* /root/bin || \
  ls -al /root/quicklisp/local-projects/bmfbp/builds/0.1 || \
  echo

# Clean up
RUN cd /root/bin && \
  rm -rf /root/quicklisp/local-projects/bmfbp

ARG program_path

COPY "${program_path}" "/root/program"

# Make Arrowgrams, refresh quicklisp, and run hello-world. This is what you would run manually.
ENTRYPOINT cd ${project_root} && \
  make  && \
  sbcl --eval "(quicklisp:register-local-projects)" --quit && \
  sbcl --eval '(ql:quickload :arrowgrams/build :silent nil)' --eval '(arrowgrams/build::arrowgrams)' --quit "/root/program" && \
  cd /root/bin && \
  python -m SimpleHTTPServer 8000
