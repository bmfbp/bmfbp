#!/usr/bin/env bash
DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Following <https://docs.haskellstack.org/en/stable/install_and_upgrade/>
# fails "sometimes"; can be very expensive
# - stack upgrade --binary-only

#stack install
#stack upgrade

# FIXME get away from privilege escalation?
sudo sh -x $DIR/get.haskellstack.org.sh

function haskell_stack_upgrade () {
    case $(uname) in
        Darwin)
            stack upgrade
            ;;
        Linux)
            stack upgrade --binary-only
            ;;
        *)
    esac
}

function haskell_stack_nonce_install () {
    tmpdir=/tmp/$$
    mkdir $tmpdir
    pushd $tmpdir
    stack new foo && pushd foo && stack install
}

haskell_stack_nonce_install

        


