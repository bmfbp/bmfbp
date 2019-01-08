STACK_TARGET=${HOME}/.local/bin
TARGET=${HOME}/bin

all: netcat-server http-receive

netcat-server:
	cp netcat-server ${TARGET}

http-receive:
	cd http-receive && stack install
	cp ${STACK_TARGET}/http-receive-exe ${TARGET}
