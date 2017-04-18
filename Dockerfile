# Use phusion/baseimage as base image. To make your builds reproducible, make
# # sure you lock down to a specific version, not to `latest`!
# # See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# # a list of version numbers.
FROM phusion/baseimage:0.9.21
# Install CellProfiler dependencies
RUN apt-get -y update                                            && \
    apt-get -y upgrade                                           && \
    apt-get -y install                                              \
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
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /usr/local/src
# Insatll CellProfiler at a specific version
RUN git clone https://github.com/CellProfiler/CellProfiler.git
WORKDIR /usr/local/src/CellProfiler
RUN git checkout tags/2.2.0
RUN pip install --editable .
ENTRYPOINT ["/sbin/my_init", "--", "cellprofiler", "--run", "--run-headless"]
CMD ["--help"]

