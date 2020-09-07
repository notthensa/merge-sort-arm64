#! /bin/bash
qemu-aarch64 -g 1234 ./bin/ms &
aarch64-linux-gnu-gdb ./bin/ms -x ./remote_gdb.txt
