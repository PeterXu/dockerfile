#!/bin/bash

set -e


ROOT=/opt/openfalcon
mod="$1"

cd $ROOT/$mod
./control start


exit 0
