FROM ubuntu:16.04
# Install CellProfiler
RUN   apt-get -y update &&                                          \
      apt-get -y install                                            \
        build-essential    \
        cython             \
        git                \
        libmysqlclient-dev \
        libhdf5-dev        \
        libxml2-dev        \
        libxslt1-dev       \
        openjdk-8-jdk      \
        python-dev         \
        python-pip         \
        python-h5py        \
        python-matplotlib  \
        python-mysqldb     \
        python-scipy       \
        python-numpy       \
        python-vigra       \
        python-wxgtk3.0    \
        python-zmq
WORKDIR /usr/local/src
ARG VERSION=stable
RUN git clone -b $VERSION https://github.com/CellProfiler/CellProfiler.git
WORKDIR /usr/local/src/CellProfiler
# Install CellProfiler at a specific version
RUN git checkout tags/2.2.0
RUN pip install                                                     \
  --editable                                                        \
    .
# Fix init problems using s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /
ENTRYPOINT ["/init", "cellprofiler"]
CMD ["--run", "--run-headless", "--help"]
