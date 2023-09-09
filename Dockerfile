# Build an x64 LLVM using manylinux2014_x86_64
FROM quay.io/pypa/manylinux2014_x86_64 as manylinux_native
COPY install_cmake_manylinux.sh /tmp/install_cmake_manylinux.sh
RUN /bin/bash /tmp/install_cmake_manylinux.sh && \
   curl -sSL -O https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-16.0.6.tar.gz && \
   tar xf llvmorg-16.0.6.tar.gz && \
   cd llvm-project-* && mkdir build && cd build && \
   /opt/native/bin/cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS='clang;lld' -DLLVM_TARGETS_TO_BUILD=AArch64 -DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-pc-linux-gnu ../llvm  -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_ZSTD=OFF -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_TARGET_ARCH=AArch64 -DLLVM_BUILD_TOOLS=OFF -DCLANG_BUILD_TOOLS=ON -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON -DGCC_INSTALL_PREFIX=/opt/rh/devtoolset-10/root -DCMAKE_INSTALL_PREFIX=/opt/native -DLLVM_STATIC_LINK_CXX_STDLIB=ON -DCLANG_ENABLE_ARCMT=OFF -DCLANG_ENABLE_STATIC_ANALYZER=OFF -DLLVM_ENABLE_THREADS=OFF && \
   make install/strip -j$(nproc) && \
   rm -rf /opt/native/share/{doc,applications,bash-completion,emacs,icons,mime,vim,opt-viewer} /opt/native/doc /tmp/install_cmake_manylinux.sh

FROM quay.io/pypa/manylinux2014_aarch64
COPY --from=manylinux_native /opt/native/ /opt/native
COPY --from=manylinux_native /lib64/libc.so.6 /lib/x64/
COPY --from=manylinux_native /lib64/libm.so.6 /lib/x64/
COPY --from=manylinux_native /lib64/libdl.so.2 /lib/x64/
COPY --from=manylinux_native /lib64/libpthread.so.0 /lib/x64/
COPY --from=manylinux_native /lib64/librt.so.1 /lib/x64/
COPY --from=manylinux_native /lib64/libgcc_s.so.1 /lib/x64/
COPY --from=manylinux_native /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-10/root/usr/lib64:/opt/rh/devtoolset-10/root/usr/lib/gcc/aarch64-redhat-linux/10/:/usr/local/lib64:/usr/local/lib:/lib/x64
