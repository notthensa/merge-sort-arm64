#! /bin/bash
qemu-aarch64 -g 1234 ./bs &
aarch64-linux-gnu-gdb ./bs -x ./remote_gdb.txt
