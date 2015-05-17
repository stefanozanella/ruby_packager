#!/bin/bash

ruby-install \
  --jobs=4 \
  -i /opt/ruby/ \
  ruby 2.1.2 \
  -- \
  --disable-install-doc \

/opt/ruby/bin/gem install bundler --no-rdoc --no-ri

mkdir -p /target/opt/ruby
mv /opt/ruby/* /target/opt/ruby
mkdir -p /target/usr/bin

for binary in $(ls -1 /target/opt/ruby/bin)
do
  ln -s /opt/ruby/bin/$binary /target/usr/bin/$binary
done

fpm \
  -s dir \
  -t deb \
  -n ruby-runtime \
  -v 2.1.2 \
  --iteration $(date +"%Y%m%d%H%M%S") \
  -m "Stefano Zanella <zanella.stefano@gmail.com>" \
  -d libgmp10 \
  -d libyaml-0-2 \
  -d libssl \
  --replaces ruby \
  --description "Ruby interpreter and associated runtime. Bundler gem included." \
  /target/=/
mv *.deb /pkg
