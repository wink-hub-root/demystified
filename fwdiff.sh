#!/bin/bash
cd extracted
VERSIONS=($(ls -a | cat | grep '[0-9]'))

typeset -i i END
let END=${#VERSIONS[@]}-2 i=0
while ((i<=END)); do
  sudo diff --no-dereference -q -r ${VERSIONS[i]}/ ${VERSIONS[i+1]}/ | grep -v "is a character special file" | grep -v "is a block special file" > ../diff/${VERSIONS[i]}-${VERSIONS[i+1]}.diff
  let i++
done
