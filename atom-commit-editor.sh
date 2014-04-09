#!/bin/bash

pipe=/tmp/atom_commit_pipe

trap "rm -f $pipe" EXIT

if [[ ! -p $pipe ]]; then
  mkfifo $pipe
fi

atom $1

while true
do
  if read line <$pipe; then
    if [[ "$line" == 'done' ]]; then
      break
    elif [[ "$line" == 'cancel' ]]; then
      exit 1
    fi
  fi
done
