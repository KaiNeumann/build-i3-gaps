#!/bin/bash

#
#     .-.,-..-..-..-..-.       Kai Uwe Neumann
#     | . < | || || .` |       (c) 2019
#     `-'`-'`----'`-'`-'       kai.uwe.neumann@gmail.com
#
#

# Builds i3-gaps for Debian stretch from source in a docker container

# Based on https://github.com/maestrogerardo/i3-gaps-deb/blob/master/i3-gaps-deb
# Dockerfile example taken from https://github.com/IronicBadger/docker-snapraid/blob/master/Dockerfile

IMAGE_TAG="i3-gaps-build"

#git clone https://gitlab.kaiuweneumann.de/kai/build-i3-gaps.git
#cd build-i3-gaps

docker build -t $IMAGE_TAG .
ID=$(docker create $IMAGE_TAG)
docker cp $ID:/build/ .
docker rm -v $ID
docker rmi $IMAGE_TAG

cd build/

# dpkg -i i3*.deb
