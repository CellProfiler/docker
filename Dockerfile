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
# Install CellProfiler at a specific version
RUN git checkout tags/2.2.0
RUN pip install                                                     \
  --editable                                                        \
    .
ENTRYPOINT ["/init"]
CMD ["cellprofiler", "--run", "--run-headless", "--help"]
