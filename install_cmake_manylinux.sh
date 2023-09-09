#!/bin/bash
#

set -ex

CMAKE_VERSION="3.18.3"
CMAKE_HASH="eb23bac95873cc0bc3946eed5d1aea6876ac03f7c0dcc6ad3a05462354b08228"
CMAKE_FILE="cmake-${CMAKE_VERSION}-Linux-$(uname -m).tar.gz"
cd /tmp
URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}"
echo "${CMAKE_HASH}  cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" >cmake.sha
curl -sSL $URL/${CMAKE_FILE} -O
sha256sum -c cmake.sha
mkdir -p /opt/native
tar -C /opt/native --strip-components=1 -xzf "${CMAKE_FILE}"
rm "${CMAKE_FILE}" cmake.sha
