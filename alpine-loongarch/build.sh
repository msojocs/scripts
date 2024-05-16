#!/bin/bash

version="240514"
wget -c https://dev.alpinelinux.org/~loongarch/edge/releases/loongarch64/alpine-minirootfs-edge-${version}-loongarch64.tar.gz

# https://docs.docker.com/build/building/base-images/
docker import alpine-minirootfs-*.tar.gz "alpine:edge-${version}"