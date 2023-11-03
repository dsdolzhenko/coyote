#!/usr/bin/env bash

set -e

# shellcheck source=config.sh
. "${BASH_SOURCE%/*}"/../config.sh

BINUTILS_VERSION="2.41"
GCC_VERSION="13.2.0"
GDB_VERSION="13.2"
OBJCONV_VERSION="01da9219e684360fd04011599805ee3e699bae96"
GRUB_VERSION="2.06"

function main {
	build_dir="$(realpath "${BASH_SOURCE%/*}")"/build

	mkdir -p "${build_dir}"
	mkdir -p "${COYOTE_TOOLCHAIN_PREFIX}"

	cd "${build_dir}"

	( build_binutils )
	( build_gcc )
	( build_gdb )
	( build_grub )

	echo "Cleaning up..."
	rm -rf "${build_dir}"
}

function build_binutils {
	echo "Building binutils"

	get_sources binutils "http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.gz"

	rm -rf build-binutils && mkdir -p "${_}" && cd "${_}"

	run "Configuring binutils" binutils.configure.log \
	    ../binutils/configure \
	        --prefix="${COYOTE_TOOLCHAIN_PREFIX}" \
	        --target="${COYOTE_TARGET}" \
	        --with-sysroot \
	        --disable-nls \
	        --disable-werror

	run "Making binutils" binutils.make.log \
	    make

	run "Installing binutils" binutils.install.log \
	    make install
}

function build_gcc {
	echo "Building gcc"

	get_sources gcc "http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"

	echo "Patching gcc"
	patch -Np1 -d gcc <../x86-64-libgcc-without-red-zone.patch >/dev/null

	rm -rf build-gcc && mkdir -p "${_}" && cd "${_}"

	run "Configuring gcc" gcc.configure.log \
	    ../gcc/configure \
	        --prefix="${COYOTE_TOOLCHAIN_PREFIX}" \
	        --target="${COYOTE_TARGET}" \
	        --disable-nls \
	        --enable-languages=c,c++ \
	        --without-headers \
	        --with-as="${COYOTE_TOOLCHAIN_PREFIX}"/bin/"${COYOTE_TARGET}"-as \
	        --with-ld="${COYOTE_TOOLCHAIN_PREFIX}"/bin/"${COYOTE_TARGET}"-ld

	run "Making gcc" gcc.make.log \
	    make all-gcc

	run "Installing gcc" gcc.install.log \
	    make install-gcc

	run "Making libgcc" libgcc.make.log \
	    make all-target-libgcc

	run "Installing libgcc" libgcc.install.log \
	    make install-target-libgcc
}

function build_gdb {
	echo "Building gdb"

	get_sources gdb "https://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.gz"

	rm -rf build-gdb && mkdir -p "${_}" && cd "${_}"

	run "Configuring gdb" gdb.configure.log \
	    ../gdb/configure \
	        --prefix="${COYOTE_TOOLCHAIN_PREFIX}" \
	        --target="${COYOTE_TARGET}" \
	        --disable-werror

	run "Making gdb" gdb.make.log \
	    make

	run "Installing gdb" gdb.install.log \
	    make install
}

function build_objconv {
	echo "Building objconv"

	get_sources objconv "https://github.com/vertis/objconv/archive/${OBJCONV_VERSION}.tar.gz"

	rm -rf build-objconv && mkdir -p "${_}" && cd "${_}"

	run "Making objconv" objconv.gcc.log \
	    g++ -o objconv -O2 ../objconv/src/*.cpp

	echo "Installing objconv"
	mv objconv "${COYOTE_TOOLCHAIN_PREFIX}"/bin/objconv
}

function build_grub {
	if [[ "${OSTYPE}" == "darwin"* ]]; then
		# https://wiki.osdev.org/GRUB#Installing_GRUB_2_on_OS_X
		build_objconv
	fi

	echo "Building grub"

	get_sources grub "https://ftp.gnu.org/gnu/grub/grub-${GRUB_VERSION}.tar.gz"

	rm -rf build-grub && mkdir -p "${_}" && cd "${_}"

	run "Configuring grub" grub.configure.log \
	    ../grub/configure \
	        --prefix="${COYOTE_TOOLCHAIN_PREFIX}" \
	        --target="${COYOTE_TARGET}" \
	        --disable-werror \
	        TARGET_CC="${COYOTE_TARGET}"-gcc \
	        TARGET_OBJCOPY="${COYOTE_TARGET}"-objcopy \
	        TARGET_STRIP="${COYOTE_TARGET}"-strip \
	        TARGET_NM="${COYOTE_TARGET}"-nm \
	        TARGET_RANLIB="${COYOTE_TARGET}"-ranlib

	run "Making grub" grub.make.log \
	    make

	run "Installing grub" grub.install.log \
	    make install
}

function run {
	msg=$1
	log=$2
	shift 2

	printf "%s..." "${msg}"
	set +e
	"$@" &> "${log}"
	status=$?
	set -e

	if [[ "${status}" -eq "0" ]]; then
		printf "\n"
	else
		printf "failed\n"
		tail "${log}"
		log_path=$(realpath "${log}")
		echo -e "\nSee the full log at ${log_path}"
		exit "${status}"
	fi
}

function get_sources {
	dest=$1
	url=$2
	archive=$(basename "${url}")

	if [[ ! -f "${archive}" ]]; then
		echo "Downloading ${url}"
		curl -s -L "${url}" -o "${archive}"
	fi

	echo "Extracting $(basename "${archive}")"
	rm -rf "${dest}" && mkdir -p "${_}"
	tar -xzf "${archive}" -C "${dest}" --strip-components=1
}

main "$@"
