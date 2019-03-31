FROM ubuntu:18.04

RUN apt-get -y update

# Deps fetching
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  build-essential \
  libgtk-3-dev \
  python \
  python-pip \
  wget

# Moddable clone and build
ENV MODDABLE /moddable

COPY make.esp32.mk /moddable/tools/mcconfig/

RUN git clone https://github.com/Moddable-OpenSource/moddable.git && \
  cd moddable/build/makefiles/lin && \
  make

# Esp-idf clone
ENV IDF_PATH /root/esp32/esp-idf

RUN mkdir ~/esp32 && cd ~/esp32 && \
  git clone --recursive https://github.com/espressif/esp-idf.git && \
  cd esp-idf && \
  git checkout release/v3.1 && \
  git submodule update && \
  pwd && \
  python -m pip install --user -r $IDF_PATH/docs/requirements.txt

# Xtensa toolchain
ENV PATH $PATH:$HOME/esp32/xtensa-esp32-elf/bin

RUN cd ~/esp32 && \
  wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz && \
  tar xvzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

# Build Folder
RUN mkdir /source && mkdir /artifacts && cd /source

ADD build.sh /source

CMD ['build.sh']
