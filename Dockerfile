FROM ubuntu:20.04

WORKDIR /

RUN apt update -y && \
      apt install -y curl autoconf build-essential curl subversion libbz2-dev libz-dev unzip libpng16-16 libsdl2-2.0-0 libfreetype6 libminiupnpc-dev && \
      rm -rf /var/lib/apt/lists/*

RUN curl -Lo libpng.deb https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/15108504/+files/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb

RUN mkdir our && \
      dpkg -x libpng.deb ./out && \
      cp ./out/lib/x86_64-linux-gnu/libpng12.so.0 /usr/lib/x86_64-linux-gnu && \
      ln -s /usr/lib/x86_64-linux-gnu/libminiupnpc.so.17 /usr/lib/x86_64-linux-gnu/libminiupnpc.so.10 && \
      ls -al /usr/lib/x86_64-linux-gnu/

RUN curl -O -L -C - https://sourceforge.net/projects/simutrans/files/simutrans/121-0/simulinux-121-0.zip

RUN unzip simulinux-121-0.zip && \
      cd simutrans && \
      chmod +x ./simutrans && \
      mkdir save && \
      mkdir addons && \
      mkdir maps && \
      cd ../

RUN cd ../ && \
      curl -O -L -C - https://sourceforge.net/projects/simutrans/files/pak64/121-0/simupak64-121-0.zip && \
      unzip simupak64-121-0.zip

RUN curl -O -L -C - https://sourceforge.net/projects/simutrans/files/pak64/121-0/simupak64-addon-food-120-4.zip && \
      unzip simupak64-addon-food-120-4.zip

RUN cd /

CMD /simutrans/simutrans -server 13353 -singleuser -lang jp -objects pak/ -nosound -nomidi -log 1 -debug 3
