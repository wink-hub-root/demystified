#!/bin/bash
sed '/^[<>]/d' $1 | tr -d '\n' | xxd -r -p > "$1.bin"
