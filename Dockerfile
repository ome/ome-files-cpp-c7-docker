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

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN pip install --upgrade pip
RUN pip install Genshi
RUN pip install Sphinx

WORKDIR /git
RUN git clone --branch='v5.4.2' https://github.com/ome/ome-common-cpp.git
RUN git clone --branch='v5.5.6' https://github.com/ome/ome-model.git
RUN git clone --branch='v0.4.0' https://github.com/ome/ome-files-cpp.git
RUN git clone --branch='v5.4.2' https://github.com/ome/ome-qtwidgets.git
RUN git clone --branch='v0.4.0' https://github.com/ome/ome-cmake-superbuild.git

WORKDIR /build
RUN cmake \
    -Dgit-dir=/git \
    -Dbuild-prerequisites=OFF \
    -Dome-superbuild_BUILD_gtest=ON \
    -Dbuild-packages=ome-files \
    -DCMAKE_BUILD_TYPE=Release \
    /git/ome-cmake-superbuild
RUN make
RUN make install
RUN ldconfig
