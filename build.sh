#! /bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
mkdir $DIR/bin
(cd $DIR/bin && aarch64-linux-gnu-as ../bs.s -o bs.o && aarch64-linux-gnu-gcc --static ../main.c bs.o -o bs)
