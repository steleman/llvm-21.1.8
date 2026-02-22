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
llvm_install="${here}/opt/llvm/${llvm_version}"
llvm_install_dir="/opt/llvm/${llvm_version}"

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

if [ -d ${llvm_install}/lib ] ; then
  echo "cd ${llvm_install}"
  cd ${llvm_install}

  echo "mv ./lib ./lib64"
  mv ./lib ./lib64

  echo "ln -sf lib64 lib"
  ln -sf lib64 lib

  echo "cd ${here}"
  cd ${here}
fi

if [ -d ${llvm_ocaml}/usr ] ; then
  echo "rm -rf ${llvm_ocaml}/usr"
  rm -rf ${llvm_ocaml}/usr
fi

if [ -e ${here}/usr ] ; then
  if [ ! -e ${llvm_ocaml}/usr ] ; then
    echo "mv ${here}/usr ${llvm_ocaml}/"
    mv ${here}/usr ${llvm_ocaml}/
  else
    echo "${llvm_ocaml}/usr already exists."
    exit 1
  fi
else
  if [ -e ${llvm_ocaml}/usr ] ; then
    :
  else
    echo "${here}/usr does not exist and neither does ${llvm_ocaml}/usr."
    exit 1
  fi
fi

if [ -d ${llvm_python}/usr ] ; then
  echo "rm -rf ${llvm_python}/usr"
  rm -rf ${llvm_python}/usr

  echo "mkdir ${llvm_python}/usr"
  mkdir ${llvm_python}/usr
fi

if [ ! -d ${llvm_install}/local ] ; then
  echo "${llvm_install}/local does not exist."
  exit 1
fi

if [ ! -d ${llvm_python}/usr ] ; then
  echo "mkdir -p ${llvm_python}/usr"
  mkdir -p ${llvm_python}/usr
fi

if [ -d ${llvm_install}/local ] ; then
  echo "mv ${llvm_install}/local ${llvm_python}/usr/"
  mv ${llvm_install}/local ${llvm_python}/usr/
fi

echo "ls -la ${llvm_python}/usr/"
ls -la ${llvm_python}/usr/

echo "ls -la ${llvm_python}/usr/local/"
ls -la ${llvm_python}/usr/local/

echo "ls -la ${llvm_python}/usr/local/lib64/"
ls -la ${llvm_python}/usr/local/lib64/

echo "ls -la ${llvm_python}/usr/local/lib64/python${python_version}/"
ls -la ${llvm_python}/usr/local/lib64/python${python_version}/

echo "ls -la ${llvm_python}/usr/local/lib64/python${python_version}/site-packages/"
ls -la ${llvm_python}/usr/local/lib64/python${python_version}/site-packages/

echo "ls -la ${llvm_python}/usr/local/lib64/python${python_version}/site-packages/lldb/"
ls -la ${llvm_python}/usr/local/lib64/python${python_version}/site-packages/lldb/

python_site_packages="${llvm_python}/usr/local/lib64/python${python_version}/site-packages"

echo "python_site_packages: ${python_site_packages}"

if [ ! -d ${python_site_packages} ] ; then
  echo "mkdir -p ${python_site_packages}"
  mkdir -p ${python_site_packages}
else
  echo "site-packages directory ${python_site_packages} already exists."
fi

if [ ! -d ${llvm_install}/python_packages/mlir_core ] ; then
  echo "${llvm_install}/python_packages/mlir_core does not exist."
  exit 1
fi

if [ -d ${llvm_install}/python_packages/mlir_core ] ; then
  if [ ! -d ${python_site_packages} ] ; then
    echo "mkdir -p ${python_site_packages}"
    mkdir -p ${python_site_packages}
  fi

  echo "cp -rpd ${llvm_install}/python_packages/mlir_core ${python_site_packages}/"
  cp -rpd ${llvm_install}/python_packages/mlir_core ${python_site_packages}/

  echo "rm -rf ${llvm_install}/python_packages"
  rm -rf ${llvm_install}/python_packages
fi

lldb_python_dir="${python_site_packages}/lldb"

echo "ls -la ${lldb_python_dir}"
ls -la ${lldb_python_dir}

if [ ! -d ${lldb_python_dir} ] ; then
  echo "${lldb_python_dir} does not exist."
  exit 1
fi

if [ -d ${lldb_python_dir} ] ; then
  echo "cd ${lldb_python_dir}"
  cd ${lldb_python_dir}

  echo "rm lldb-argdumper _lldb.cpython-313-x86_64-linux-gnu.so"
  rm lldb-argdumper _lldb.cpython-313-x86_64-linux-gnu.so

  echo "ln -sf ${llvm_install_dir}/lib64/liblldb.so _lldb.cpython-313-x86_64-linux-gnu.so"
  ln -sf ${llvm_install_dir}/lib64/liblldb.so _lldb.cpython-313-x86_64-linux-gnu.so

  echo "ln -sf ${llvm_install_dir}/bin/lldb-argdumper"
  ln -sf ${llvm_install_dir}/bin/lldb-argdumper

  echo "cd ${here}"
  cd ${here}
fi

if [ ! -d ${llvm_src} ] ; then
  echo "${llvm_src} does not exist."
  exit 1
fi

local_llvm_examples="${llvm_install}/examples"

if [ ! -d ${local_llvm_examples} ] ; then
  echo "${local_llvm_examples} does not exist."
  exit 1
fi

if [ -d ${llvm_examples}/${llvm_install_dir}/examples ] ; then
  echo "rm -rf ${llvm_examples}/${llvm_install_dir}/examples"
  rm -rf ${llvm_examples}/${llvm_install_dir}/examples
fi

echo "mkdir -p ${llvm_examples}/${llvm_install_dir}"
mkdir -p ${llvm_examples}/${llvm_install_dir}

echo "mv ${local_llvm_examples} ${llvm_examples}/${llvm_install_dir}/"
mv ${local_llvm_examples} ${llvm_examples}/${llvm_install_dir}/

local_llvm_src="${llvm_install}/src"

if [ ! -d ${local_llvm_src} ] ; then
  echo "${local_llvm_src} does not exist."
  exit 1
fi

echo "ls -la ${local_llvm_src}/"
ls -la ${local_llvm_src}/

if [ -d ${llvm_src}/${llvm_install_dir}/src ] ; then
  echo "rm -rf ${llvm_src}/${llvm_install_dir}/src"
  rm -rf ${llvm_src}/${llvm_install_dir}/src
fi

echo "mkdir -p ${llvm_src}/${llvm_install_dir}"
mkdir -p ${llvm_src}/${llvm_install_dir}

echo "cp -rpd ${local_llvm_src} ${llvm_src}/${llvm_install_dir}/"
cp -rpd ${local_llvm_src} ${llvm_src}/${llvm_install_dir}/

echo "ls -la ${llvm_src}/${llvm_install_dir}/"
ls -la ${llvm_src}/${llvm_install_dir}/

echo "ls -la ${llvm_src}/${llvm_install_dir}/src/"
ls -la ${llvm_src}/${llvm_install_dir}/src/

local_toplevel_src="${here}/src"

echo "ls -la ${local_toplevel_src}/"
ls -la ${local_toplevel_src}/

local_llvm_runtimes="${local_toplevel_src}/steleman/programming/llvm-${llvm_version}/build-llvm/runtimes"

if [ ! -d ${local_llvm_runtimes} ] ; then
  echo "${local_llvm_runtimes} does not exist."
  exit 1
fi

echo "ls -la ${local_llvm_runtimes}"
ls -la ${local_llvm_runtimes}

if [ -d ${llvm_runtimes}/opt ] ; then
  echo "rm -rf ${llvm_runtimes}/opt"
  rm -rf ${llvm_runtimes}/opt
fi

echo "mkdir -p ${llvm_runtimes}/${llvm_install_dir}"
mkdir -p ${llvm_runtimes}/${llvm_install_dir}

if [ -d ${local_llvm_runtimes} ] ; then
  echo "cp -rpd ${local_llvm_runtimes} ${llvm_runtimes}/${llvm_install_dir}/"
  cp -rpd ${local_llvm_runtimes} ${llvm_runtimes}/${llvm_install_dir}/

  if [ -d ${llvm_runtimes}/${llvm_install_dir}/runtimes ] ; then
    echo "ls -la ${llvm_runtimes}/${llvm_install_dir}/runtimes/"
    ls -la ${llvm_runtimes}/${llvm_install_dir}/runtimes/

    echo "rm -rf ${local_llvm_runtimes}"
    rm -rf ${local_llvm_runtimes}
  fi
fi

echo "rm -rf ${local_llvm_src}"
rm -rf ${local_llvm_src}

echo "Done."


