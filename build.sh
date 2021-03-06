#!/bin/bash

#
#     .-.,-..-..-..-..-.       Kai Uwe Neumann
#     | . < | || || .` |       (c) 2019
#     `-'`-'`----'`-'`-'       kai.uwe.neumann@gmail.com
#
#
# Build i3-gaps window manager for Debian stretch from source in a docker container
#
# Using i3-gaps fork from https://www.github.com/Airblader/i3
# Based on installer script https://github.com/maestrogerardo/i3-gaps-deb/blob/master/i3-gaps-deb
# Converted to dockerized build, inspired by https://github.com/IronicBadger/docker-snapraid/
#
# Usage:
#
# 1) Build on docker host
#   git clone https://gitlab.kaiuweneumann.de/kai/build-i3-gaps.git
#   cd build-i3-gaps
#   chmod +x build.sh
#   ./build.sh
#
# 2) install from build packages
#   sudo dpkg -i build/i3*.deb
#

IMAGE_TAG="i3-gaps-build"

#build from dockerfile
docker build -t $IMAGE_TAG .

#create container and get volume
ID=$(docker create $IMAGE_TAG)

#copy built deb packages from volume
docker cp $ID:/build/ .

#remove container including all volumes
docker rm -v $ID

#remove build image
docker rmi $IMAGE_TAG
