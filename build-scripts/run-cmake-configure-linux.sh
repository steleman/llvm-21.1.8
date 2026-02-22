#!/bin/bash

llvm_version="21.1.8"
here="`pwd`"
topdir="`dirname ${here}`"
srcdir="${topdir}/llvm-${llvm_version}"
lldb_incdir="${srcdir}/lldb/include/lldb"
build_lldbincdir="${here}/include/lldb"
llvm_cmake_dir="${srcdir}/llvm"
outfile="${here}/configure-llvm.out"
cmake_outfile="${here}/cmake-configure-llvm.out"
cret=0
distro="`uname -s`"
linker_type="BFD"
bfd_linker_flags="-flto"

if [ "${distro}" != "Linux" ] ; then
  echo "This cmake configure script only works on Linux."
  exit 1
fi

export CUDA="/usr/local/cuda-12.9"
export ROCM="/opt/rocm-6.4.3"

export PATH="/usr/local/${CUDA}/bin:/opt/${ROCM}/bin:${PATH}"
export GMAKE="/usr/bin/gmake"
export MAKE="${GMAKE}"
export CMAKE="/usr/bin/cmake"

export CC="/usr/bin/gcc"
export CXX="/usr/bin/g++"
export CFLAGS="-Wall -Wextra"
export CXXFLAGS="-Wall -Wextra"
export CPPFLAGS=""
export CMAKE_FLAGS=""

gsed="/usr/bin/sed"
cmakear="/usr/bin/ar"
python_executable="/usr/bin/python3"
build_type="Release"

libffi_incdir="/usr/include"
libffi_libdir="/usr/lib64"

prefix="/opt/llvm/${llvm_version}"
cmake_install_bindir="${prefix}/bin"
cmake_install_libdir="${prefix}/lib64"
cmake_install_rpath="${cmake_install_libdir}"
cmake_build_rpath="${here}/lib64;${here}/lib;${cmake_install_rpath}"
cmake_install_libexecdir="${prefix}/libexec"
cmake_install_incdir="${prefix}/include"
cmake_install_datadir="${prefix}/share"
llvm_targets="X86\;NVPTX\;AMDGPU"

cmake_flags="-DCMAKE_INSTALL_PREFIX=${prefix}"
cmake_flags="${cmake_flags} -DCMAKE_BUILD_TYPE=${build_type}"
cmake_flags="${cmake_flags} -DCMAKE_C_VISIBILITY_PRESET:STRING=default"
cmake_flags="${cmake_flags} -DCMAKE_CXX_VISIBILITY_PRESET:STRING=default"
cmake_flags="${cmake_flags} -DCMAKE_C_COMPILER=${CC}"
cmake_flags="${cmake_flags} -DCMAKE_CXX_COMPILER=${CXX}"
cmake_flags="${cmake_flags} -DCMAKE_C_FLAGS=${CFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_CXX_FLAGS=${CXXFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_C_FLAGS_RELEASE=${CFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_CXX_FLAGS_RELEASE=${CXXFLAGS}"
cmake_flags="${cmake_flags} -DCMAKE_LINKER_TYPE:STRING=${linker_type}"
cmake_flags="${cmake_flags} -DCMAKE_EXE_LINKER_FLAGS:STRING=${bfd_linker_flags}"
cmake_flags="${cmake_flags} -DCMAKE_SHARED_LINKER_FLAGS:STRING=${bfd_linker_flags}"
cmake_flags="${cmake_flags} -DCMAKE_MODULE_LINKER_FLAGS:STRING=${bfd_linker_flags}"
cmake_flags="${cmake_flags} -DCMAKE_AR:FILEPATH=${cmakear}"
cmake_flags="${cmake_flags} -DCMAKE_C_STANDARD=11"
cmake_flags="${cmake_flags} -DCMAKE_CXX_STANDARD=17"
cmake_flags="${cmake_flags} -DCMAKE_C_EXTENSIONS:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_CXX_EXTENSIONS:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_BUILD_TYPE:STRING=${build_type}"
cmake_flags="${cmake_flags} -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_SUPPRESS_REGENERATION:BOOL=ON"
cmake_flags="${cmake_flags} -DCMAKE_BUILD_RPATH:STRING=${cmake_build_rpath}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_RPATH:STRING=${cmake_install_rpath}"

cmake_flags="${cmake_flags} -DCMAKE_INSTALL_BINDIR:FILEPATH=${cmake_install_bindir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_LIBDIR:FILEPATH=${cmake_install_libdir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_LIBEXECDIR:FILEPATH=${cmake_install_libexecdir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_INCLUDEDIR:FILEPATH=${cmake_install_incdir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_DATADIR:FILEPATH=${cmake_install_datadir}"
cmake_flags="${cmake_flags} -DCMAKE_INSTALL_DATAROOTDIR:FILEPATH=${cmake_install_datadir}"
cmake_flags="${cmake_flags} -DLLVM_TARGETS_TO_BUILD:STRING=${llvm_targets}"
cmake_flags="${cmake_flags} -DCMAKE_MAKE_PROGRAM:FILEPATH=${GMAKE}"
cmake_flags="${cmake_flags} -DCMAKE_ASM_COMPILER:FILEPATH=${CC}"
cmake_flags="${cmake_flags} -DLLVM_BUILD_TOOLS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INCLUDE_TOOLS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_BUILD_TESTS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INCLUDE_TESTS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_THREADS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_BUILD_32_BITS:BOOL=OFF"
cmake_flags="${cmake_flags} -DLLVM_BUILD_EXAMPLES:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INCLUDE_EXAMPLES:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_EH:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_PIC:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_RTTI:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_WARNINGS:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_PEDANTIC:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_ZLIB:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_FFI:BOOL=ON"
cmake_flags="${cmake_flags} -DFFI_INCLUDE_DIR:FILEPATH=${libffi_incdir}"
cmake_flags="${cmake_flags} -DFFI_LIBRARY_DIR:FILEPATH=${libffi_libdir}"
cmake_flags="${cmake_flags} -DLLVM_BUILD_STATIC:BOOL=OFF"
cmake_flags="${cmake_flags} -DLLVM_BUILD_LLVM_DYLIB:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_LINK_LLVM_DYLIB:BOOL=OFF"
cmake_flags="${cmake_flags} -DLLVM_COMPILER_IS_GCC_COMPATIBLE:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_PROJECTS='llvm;clang;clang-tools-extra;mlir;lldb;lld;polly'"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_RUNTIMES='compiler-rt;libcxxabi;libunwind;libcxx;openmp;libclc'"
cmake_flags="${cmake_flags} -DLLVM_ENABLE_Z3_SOLVER:BOOL=ON"
cmake_flags="${cmake_flags} -DLLVM_INSTALL_UTILS:BOOL=ON"
cmake_flags="${cmake_flags} -DMLIR_ENABLE_BINDINGS_PYTHON:BOOL=ON"
cmake_flags="${cmake_flags} -DLLDB_USE_SYSTEM_DEBUGSERVER:BOOL=ON"
cmake_flags="${cmake_flags} -DPython3_EXECUTABLE:FILEPATH=${python_executable}"
cmake_flags="${cmake_flags} -DLIBOMP_ARCH=X86"
cmake_flags="${cmake_flags} -DLIBOMP_LIB_TYPE=normal"
cmake_flags="${cmake_flags} -DLIBOMP_OMP_VERSION=50"
cmake_flags="${cmake_flags} -DOPENMP_ENABLE_LIBOMPTARGET=on"

${CC} --version
${CXX} --version

cat /dev/null > ${outfile}
echo "Running ${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir}"
echo "Running ${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir}" >> ${cmake_outfile} 2<&1
echo "Running ${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir}" >> ${outfile} 2>&1
${CMAKE} ${CMAKE_FLAGS} ${cmake_flags} ${llvm_cmake_dir} >> ${outfile} 2>&1
cret=$?

if [ ${cret} -ne 0 ] ; then
  echo "CMake configuration failed."
  exit 1
fi

echo "Fixing bad compile flags from CMake ..."
echo "Fixing bad compile flags from CMake ..." >> ${outfile} 2>&1

listfile="/tmp/bad-compilerflags.$$"
cat /dev/null > ${listfile}

find . -type f -name "*.make" -print >> ${listfile} 2>&1

while read -r line
do
  cp -fp ${line} "${line}.orig"
  ${gsed} -i 's#-fvisibility-inlines-hidden##g' ${line}
  ${gsed} -i 's#-fvisibility=hidden##g' ${line}
  ${gsed} -i 's#-fvisibility=default##g' ${line}
  ${gsed} -i 's#-fno-semantic-interposition##g' ${line}
  ${gsed} -i 's#-Wall -Wextra#-Wall -Wextra -DNDEBUG#g' ${line}
  ${gsed} -i 's#-DNDEBUG#-DNDEBUG -DLLVM_ENABLE_DUMP#g' ${line}
  touch -r "${line}.orig" -acm ${line}
  rm -f "${line}.orig"
done < ${listfile}

rm -f ${listfile}

echo "Fixing bad linker flags from CMake ..."
echo "Fixing bad linker flags from CMake ..." >> ${outfile} 2>&1

listfile="/tmp/link-relocations.$$"
cat /dev/null > ${listfile}

find . -type f -name "link.txt" -print >> ${listfile} 2>&1

while read -r line
do
  cp -fp ${line} "${line}.orig"
  ${gsed} -i 's#-fno-semantic-interposition##g' ${line}
  ${gsed} -i 's#-fvisibility=hidden##g' ${line}
  ${gsed} -i 's#-fvisibility=default##g' ${line}
  ${gsed} -i 's#-fvisibility-inlines-hidden##g' ${line}
  touch -r "${line}.orig" -acm ${line}
  rm -f "${line}.orig"
done < ${listfile}

rm -f ${listfile}

echo "Fixing OCaml linker crap ..."
echo "Fixing OCaml linker crap ..." >> ${outfile} 2>&1

listfile="/tmp/badocaml-link.$$"
cat /dev/null > ${listfile}

find . -type f -name "build.make" -print >> ${listfile} 2>&1
find . -type f -name "link.txt" -print >> ${listfile} 2>&1

while read -r line
do
  cp -fp ${line} "${line}.orig"
  ${gsed} -i 's#-l/opt/homebrew/lib/libz3.dylib#-L/opt/homebrew/lib -lz3#g' ${line}
  touch -r "${line}.orig" -acm ${line}
  rm -f "${line}.orig"
done < ${listfile}

rm -f ${listfile}

echo "CMake configuration finished."
echo "CMake configuration finished." >> ${outfile} 2>&1

