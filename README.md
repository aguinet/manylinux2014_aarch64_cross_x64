# manylinux/aarch64 with a linux/x64 compiler

This docker is based on `manylinux2014_aarch64` and adds a linux/x64 Clang
compiler that targets ARM64.

The goal is still to be able to compile at "native performance" ARM64 Python
extensions. This is used in the
[DragonFFI](https://github.com/aguinet/dragonffi) project to compile LLVM for
manylinux2014/aarch64 and keep a reasonable time.

Image is built by Github actions and pushed on [Docker
hub](https://hub.docker.com/r/aguinet/manylinux2014_aarch64_cross_x64). You can
directly use the image `aguinet/manylinux2014_aarch64_cross_x64`.

Clang is accessible at `/opt/native/bin/clang` and should be usable directly as
a drop-in of GCC. An x64 cmake is also available in `/opt/native/bin/cmake`.
