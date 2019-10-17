FROM ubuntu:18.04

# Install dependencies
RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  build-essential \
  libgtk-3-dev \
  python \
  python-pip \
  python-setuptools \
  python-serial \
  wget \
  flex bison \
  gperf \
  libncurses5-dev libncursesw5-dev

# Install Moddable
ENV MODDABLE /root/moddable
WORKDIR /root
RUN git clone https://github.com/Moddable-OpenSource/moddable.git
WORKDIR /root/moddable/build/makefiles/lin
RUN make
ENV PATH $PATH:${MODDABLE}/build/bin/lin/release

# Install ESP-IDF
ENV IDF_PATH /root/esp32/esp-idf
RUN mkdir /root/esp32 
WORKDIR /root/esp32
RUN git clone -b v3.2.2 --recursive https://github.com/espressif/esp-idf.git
RUN python -m pip install --user -r $IDF_PATH/docs/requirements.txt

# Xtensa toolchain
ENV PATH $PATH:/root/esp32/xtensa-esp32-elf/bin
WORKDIR /root/esp32
RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz && \
    tar xvzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

# Build Folder
RUN mkdir /source
VOLUME ["/source"]

ADD build.sh /
RUN chmod 755 /build.sh

WORKDIR /source

CMD ["/bin/sh", "/build.sh"]
