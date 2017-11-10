FROM centos:centos7
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN yum -y install epel-release && yum -y update && yum -y clean all

RUN yum groupinstall -y "Development Tools"
RUN yum install -y \
  cmake3 \
  git \
  man \
  boost-devel \
  xerces-c-devel \
  xalan-c-devel \
  libpng-devel \
  gtest-devel \
  libtiff-devel \
  locales \
  python-pip

RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-4-toolchain

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN pip install --upgrade pip
RUN pip install Genshi
RUN pip install Sphinx

WORKDIR /git
RUN git clone --branch='master' https://github.com/ome/ome-common-cpp
RUN git clone --branch='master' https://github.com/ome/ome-model
RUN git clone --branch='master' https://github.com/ome/ome-files-cpp
RUN git clone --branch='master' https://github.com/ome/ome-cmake-superbuild

WORKDIR /build
RUN scl enable devtoolset-4 -- cmake3 \
    -Dgit-dir=/git \
    -Dbuild-prerequisites=OFF \
    -Dome-superbuild_BUILD_gtest=ON \
    -Dbuild-packages=ome-files \
    -DCMAKE_BUILD_TYPE=Release \
    /git/ome-cmake-superbuild
RUN scl enable devtoolset-4 -- make
RUN scl enable devtoolset-4 -- make install
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/usr-local.conf
RUN ldconfig
