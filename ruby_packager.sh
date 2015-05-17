#!/bin/bash

mkdir $BUILD_DIR $PKG_DIR

ruby-install \
  --jobs=${BUILD_CPUS} \
  -i ${INSTALL_DIR} \
  ${RUBY_TYPE} ${RUBY_VERSION} \
  -- \
  --disable-install-doc \

${INSTALL_DIR}/bin/gem install bundler --no-rdoc --no-ri

mkdir -p ${BUILD_DIR}/${INSTALL_DIR}
mv ${INSTALL_DIR}/* ${BUILD_DIR}/${INSTALL_DIR}
mkdir -p ${BUILD_DIR}/usr/bin

for binary in $(ls -1 ${BUILD_DIR}/${INSTALL_DIR}/bin)
do
  ln -s ${INSTALL_DIR}/bin/$binary ${BUILD_DIR}/usr/bin/$binary
done

fpm \
  -s dir \
  -t deb \
  -n ${PKG_NAME} \
  -v ${RUBY_VERSION} \
  --iteration $(date +"%Y%m%d%H%M%S") \
  -m "Stefano Zanella <zanella.stefano@gmail.com>" \
  -d libgmp10 \
  -d libyaml-0-2 \
  -d libssl \
  --replaces ruby \
  --description "Ruby interpreter and associated runtime. Bundler gem included." \
  ${BUILD_DIR}/=/

mv *.deb ${PKG_DIR}
