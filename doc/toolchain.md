# Toolchain

Coyote comes with a custom toolchain that includes GCC cross-compiler and GNU binutils required to compile the OS, as well as GDB and GRUB configured to be used with the target architecture.

The toolchain doesn't include QEMU. You need to install it separately.

## Prerequisites

To build the toolchain the following programs and libraries must be installed first:

- curl
- make, autoconf, automake, texinfo, bison, flex, gmp, mpc, mpfr
- a C compiler (gcc or clang)

### Debian/Ubuntu

```
sudo apt-get install -y curl build-essential bison flex texinfo libgmp3-dev libmpc-dev libmpfr-dev
```

### MacOS (homebrew)

```
brew install curl autoconf automake bison flex texinfo gmp libmpc mpfr
```

## Building

Once all the dependencies are installed, run `./toolchain/build.sh` script.

The script installs the packages to `./toolchain/root` directory within the project tree. Normally you don't need to add it to your system's `PATH` as the scripts used to compile and run the OS add it automatically.

By default, the script will run `make` in a single-threaded mode, to take advantage of all available CPUs, run the script with `MAKEFLAGS="-j$(nproc)"` environment variable.
