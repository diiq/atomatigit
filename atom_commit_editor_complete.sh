#!/bin/bash

pipe=/tmp/atom_commit_pipe

if [[ ! -p $pipe ]]; then
  exit 1
fi


if [[ "$1" ]]; then
  echo "$1" >$pipe
fi
