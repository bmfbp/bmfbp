#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Following <https://docs.haskellstack.org/en/stable/install_and_upgrade/>
# fails "sometimes"; can be very expensive
# - stack upgrade --binary-only

#stack install
#stack upgrade

case $(uname) in
    Darwin)
        stack upgrade
    ;;
    Linux)
        stack upgrade --binary-only
    ;;
    *)
esac

tmpdir=/tmp/$$
mkdir $tmpdir
pushd $tmpdir
stack new foo && cd foo && stack install
popd
popd
        
# FIXME do we need privilege escalation?
#sudo sh -x $DIR/get.haskellstack.org.sh


