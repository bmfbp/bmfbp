# Instructions:
#
# 1. Download Docker at `https://www.docker.com/`
#
# 2. After installation, make sure your Docker engine is set to allow for at least 4 GB of memory.
#
# 3. Run `docker build .` in the directory that this file is in. You will see the following at the end:
#
#      ---> 17408eb201c5
#      Successfully built 17408eb201c5
#
#    That is the image ID. We'll use it below.
#
# 4. Run the image (using the image ID): `docker run 17408eb201c5`. You will see something like this at the end:
#
#      react node "TOP"
#      react "world"
#      react "string-join" with "string-join" "b" "world"
#      react "hello"
#      react "string-join" with "string-join" "a" "hello"
#      "TOP" outputs on pin "result" : "helloworld"
#
#      Dispatcher Finished
#
#      terminating - ready list is nil
#
# 5. To update the diagram, run `docker run -dt ${imageName}`. The image will run as a detached container.
#
# 6. Shell into the running container to modify the diagram: `docker exec -it ${containerId} sh`.

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

# Clone Arrowgrams
RUN cd /root/quicklisp/local-projects && \
  git clone https://github.com/bmfbp/bmfbp && \
  cd /root/quicklisp/local-projects/bmfbp && \
  git checkout pt-20200106

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

# Make Arrowgrams
RUN cd /root/quicklisp/local-projects/bmfbp && \
  make

# Refresh quicklisp
RUN cd /root/quicklisp/local-projects/bmfbp && \
  sbcl --eval "(quicklisp:register-local-projects)" --quit

# Run hello-world
CMD cd /root/quicklisp/local-projects/bmfbp && \
  sbcl --eval "(quicklisp:quickload :arrowgrams/build)" --eval "(arrowgrams/build::helloworld)" --quit
