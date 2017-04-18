FROM ubuntu:14.04
# Fix init problems using s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /
# Install CellProfiler
RUN apt-get -y update                                            && \
    apt-get -y upgrade                                           && \
    apt-get -y install                                              \
      cython                                                        \
      git                                                           \
      openjdk-7-jdk                                                 \
      python-h5py                                                   \
      python-imaging                                                \
      python-libtiff                                                \
      python-lxml                                                   \
      python-matplotlib                                             \
      python-mysqldb                                                \
      python-numpy                                                  \
      python-pandas                                                 \
      python-pip                                                    \
      python-scipy                                                  \
      python-skimage                                                \
      python-sklearn                                                \
      python-vigra                                                  \
      python-wxgtk2.8                                               \
      python-zmq                                                    \
      xvfb
WORKDIR /usr/local/src
RUN git clone https://github.com/CellProfiler/CellProfiler.git
WORKDIR /usr/local/src/CellProfiler
RUN pip install                                                     \
  --editable                                                        \
    .
ENTRYPOINT ["cellprofiler", "--run", "--run-headless"]
CMD ["--help"]

# Use phusion/baseimage as base image. To make your builds reproducible, make
# # sure you lock down to a specific version, not to `latest`!
# # See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# # a list of version numbers.
FROM phusion/baseimage:0.9.21
# Install CellProfiler dependencies
RUN apt-get -y update                                            && \
    apt-get -y upgrade                                           && \
    apt-get -y install                                              \
      libmysqlclient-dev                                             \
      cython                                                        \
      git                                                           \
      openjdk-8-jdk                                                 \
      python-h5py                                                   \
      python-imaging                                                \
      python-libtiff                                                \
      python-lxml                                                   \
      python-matplotlib                                             \
      python-mysqldb                                                \
      python-numpy                                                  \
      python-pandas                                                 \
      python-pip                                                    \
      python-scipy                                                  \
      python-skimage                                                \
      python-sklearn                                                \
      python-vigra                                                  \
      python-wxgtk3.0                                               \
      python-zmq                                                    \
      xvfb
WORKDIR /usr/local/src
ENTRYPOINT ["/init"]
# Install CellProfiler at a specific version
RUN git clone https://github.com/CellProfiler/CellProfiler.git
WORKDIR /usr/local/src/CellProfiler
RUN git checkout tags/2.2.0
RUN pip install                                                     \
  --editable                                                        \
    .
ENTRYPOINT ["/init"]
CMD ["cellprofiler", "--run", "--run-headless", "--help"]
