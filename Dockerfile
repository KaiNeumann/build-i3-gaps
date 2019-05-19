#                    
#     .-.,-..-..-..-..-.       Kai Uwe Neumann
#     | . < | || || .` |       (c) 2019
#     `-'`-'`----'`-'`-'       kai.uwe.neumann@gmail.com
#  
#

FROM debian:stretch

MAINTAINER KaiUweNeumann <kai.uwe.neumann@gmail.com>

# Builds i3-gaps for Debian stretch from source
# Based on https://github.com/maestrogerardo/i3-gaps-deb/blob/master/i3-gaps-deb
# Dockerfile example taken from https://github.com/IronicBadger/docker-snapraid/blob/master/Dockerfile

RUN echo "deb-src http://ftp.de.debian.org/debian/ stretch main" >> /etc/apt/sources.list && \
  echo "deb-src http://ftp.de.debian.org/debian/ stretch-updates main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get upgrade -y

RUN  apt-get install -y \
    i3 \
    apt-utils \
    git \
    devscripts \
    dpkg-dev \
    dh-autoreconf \
    libxcb-xrm-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxcb-shape0-dev

RUN apt-get build-dep -y i3-wm

RUN mkdir ~/patches && \
  curl https://raw.githubusercontent.com/maestrogerardo/i3-gaps-deb/master/patches/0001-debian-Disable-sanitizers.patch -o ~/patches/0001-debian-Disable-sanitizers.patch && \
  git clone https://www.github.com/Airblader/i3 ~/i3-gaps && \
  cd ~/i3-gaps && \
  git checkout gaps && \
  git pull && \
  patch --forward -r - -p1 <~/patches/0001-debian-Disable-sanitizers.patch && \
  echo "\n" >>debian/rules && \
  echo "override_dh_install:\n" >>debian/rules && \
  echo "override_dh_installdocs:\n" >>debian/rules && \
  echo "override_dh_installman:\n" >>debian/rules && \
  echo "\tdh_install -O--parallel\n" >>debian/rules && \
  dpkg-buildpackage -us -uc && \
  mkdir /build && \
  ls -la ~/*.deb && \
  cp ~/*.deb /build/
  
