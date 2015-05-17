FROM debian:latest
MAINTAINER Stefano Zanella <zanella.stefano@gmail.com>

RUN apt-get update

RUN apt-get -y install make wget
RUN apt-get -y install \
  build-essential \
  zlib1g-dev \
  libyaml-dev \
  libssl-dev \
  libgdbm-dev \
  libreadline-dev \
  libncurses5-dev \
  libffi-dev

RUN apt-get -y install ruby ruby-dev
RUN gem install fpm --no-ri --no-rdoc

RUN apt-get clean

RUN mkdir /target /pkg

ADD ruby-install-0.5.0.tar.gz /tmp/

WORKDIR /tmp/ruby-install-0.5.0
RUN make install

WORKDIR /
RUN rm -rf /tmp/ruby-install-0.5.0

ADD ruby_packager.sh /ruby_packager.sh

CMD [ "/ruby_packager.sh" ]
