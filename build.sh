#! /bin/bash
set x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir $DIR/bin || true
(cd $DIR/bin && aarch64-linux-gnu-as ../ms.S -o ms.o && aarch64-linux-gnu-gcc --static ../main.c ms.o -o ms) | tee /dev/tty
