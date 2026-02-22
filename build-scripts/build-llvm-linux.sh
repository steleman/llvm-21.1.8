#!/bin/bash

llvm_version="21.1.8"
here="`pwd`"
topdir="`dirname ${here}`"
srcdir="${topdir}/llvm-${llvm_version}"
llvm_cmake_dir="${srcdir}/llvm"
cret=0
distro="`uname -s`"

if [ "${distro}" != "Linux" ] ; then
  echo "This cmake configure script only works on Linux."
  exit 1
fi

gsed="/usr/bin/sed"
python_executable="/usr/bin/python3"
build_type="Release"
njobs="4"
output_file="${here}/llvm-build.log"

export CUDA="/usr/local/cuda-12.9"
export ROCM="/opt/rocm-6.4.3"
export PATH="${CUDA}/bin:${ROCM}/bin:${PATH}"
export LD_LIBRARY_PATH="${here}/lib64:${here}/lib"
export GMAKE="/usr/bin/gmake"
export MAKE="${GMAKE}"
export CMAKE="/usr/bin/cmake"
export CC="/usr/bin/gcc"
export CXX="/usr/bin/g++"
export CFLAGS="-Wall -Wextra"
export CXXFLAGS="-Wall -Wextra"

${CC} --version
${CXX} --version

cat /dev/null > ${output_file}

echo "Building LLVM ..."
echo "gmake -j${njobs} >> ${output_file} 2>&1"
gmake -j${njobs} >> ${output_file} 2>&1
cret=$?

if [ ${cret} -ne 0 ] ; then
  echo "LLVM build FAILED."
  exit 1
fi

echo "LLVM build OK."

