#!/bin/bash

here="`pwd`"
topdir="`dirname ${here}`"
llvm_version="21.1.8"
python_version="3.13"
llvm_ocaml="${topdir}/install-llvm-ocaml"
llvm_python="${topdir}/install-llvm-python3"
llvm_runtimes="${topdir}/install-llvm-runtimes"
llvm_examples="${topdir}/install-llvm-examples"
llvm_src="${topdir}/install-llvm-src"

echo "rm -rf ${llvm_ocaml}/usr"
rm -rf ${llvm_ocaml}/usr

echo "rm -rf ${llvm_runtimes}/opt"
rm -rf ${llvm_runtimes}/opt

echo "rm -rf ${llvm_python}/usr"
rm -rf ${llvm_python}/usr

echo "rm -rf ${llvm_examples}/opt"
rm -rf ${llvm_examples}/opt

echo "rm -rf ${llvm_src}/opt"
rm -rf ${llvm_src}/opt

echo "rm -rf ${here}/opt"
rm -rf ${here}/opt

echo "rm -rf ${here}/src"
rm -rf ${here}/src

