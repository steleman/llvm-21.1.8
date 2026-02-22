#!/bin/bash

if [ `id -u` -ne 0 ] ; then
  echo "You must be root to do this."
  exit 1
fi

for file in \
  llvm-21-src-local-21.1.8-300.fc41.x86_64.rpm \
  llvm-21-examples-local-21.1.8-300.fc41.x86_64.rpm \
  llvm-21-python3-local-21.1.8-300.fc41.x86_64.rpm \
  llvm-21-ocaml-local-21.1.8-300.fc41.x86_64.rpm \
  llvm-21-runtimes-local-21.1.8-300.fc41.x86_64.rpm \
  llvm-21-local-21.1.8-300.fc41.x86_64.rpm
do
  if [ -e ./${file} ] ; then
    echo "rpm -e ./${file}"
    rpm -i --force --nodeps ./${file}
  else
    echo "file ${file} was not found."
    exit 1
  fi
done

