# Instructions:
#
# 1. Download Docker at `https://www.docker.com/`
#
# 2. After installation, make sure your Docker engine is set to allow for at least 4 GB of memory.
#
# 3. Run `./build.sh` to build and run. The session will exit after putting the docker container in the background.
#
# 4. The editor is available at http://localhost:8000/dist/index.html
#
# 5. Repeat step 3 to rebuild after making a change.

FROM ubuntu:18.04

ENV program_path "build_process/parts/diagram/helloworld.svg"
ENV project_root "/root/quicklisp/local-projects/bmfbp"

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
  make  && \
  cd /root/quicklisp/local-projects/bmfbp/editor && \
  make && \
  cd /root && \
  rm -rf /root/quicklisp/local-projects/bmfbp

# Make Arrowgrams, refresh quicklisp, and run hello-world. This is what you would run manually.
CMD cd ${project_root} && \
  make  && \
  sbcl --eval "(quicklisp:register-local-projects)" --quit && \
  sbcl --eval '(ql:quickload :arrowgrams/build :silent nil)' --eval '(arrowgrams/build::arrowgrams)' --quit ${project_root}/${program_path} && \
  cd /root/quicklisp/local-projects/bmfbp/editor && \
  elm reactor
