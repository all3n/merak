build_pkg(){
  local repo="$1"
  local REVISION="$2"
  local SHA1="$3"
  local BUILD_OPTIONS="$4"
  local name=$(basename $repo)
  local url="https://api.github.com/repos/${repo}/tarball/${REVISION}"
  
  local DEP_BUILD_DIR=$DEP_DIR/build/$repo/$REVISION
  local DEP_PKG=$DEP_PKG_DIR/$repo
  local DEP_SRC=$DEP_SRC_DIR/$repo/${REVISION}
  local DEP_INSTALL=$DEP_INSTALL_DIR/$repo/${REVISION}
  local DEP_INSTALL_LATEST=$DEP_INSTALL_DIR/$repo/latest
  local TAR_FILE=$DEP_PKG/$name_${REVISION}.tar.gz 

  # download pkg
  mkdir -p $DEP_PKG $DEP_SRC $DEP_INSTALL $DEP_BUILD_DIR
  if [[ -f $TAR_FILE ]];then
    local TAR_SHA=$(sha1sum $TAR_FILE|awk '{print $1}')
    if [[ "$TAR_SHA" != "$SHA1" ]];then
      wget -O $TAR_FILE $url
    fi
  else
    wget -O $TAR_FILE $url
  fi

  # uncompress to dir
  FNUM=$(ls $DEP_SRC|wc -l)
  if [[ $FNUM -eq 0 ]];then
    tar -zxf $TAR_FILE -C $DEP_SRC --strip-components=1
  fi

  # build pkg
  local DEP_REVISION=$DEP_INSTALL/.revision
  if [[ ! -f $DEP_REVISION ]];then
    cd $DEP_BUILD_DIR
    cmake -DCMAKE_INSTALL_PREFIX=$DEP_INSTALL $BUILD_OPTIONS $DEP_SRC
    make -j$(nproc)
    make install
    if [[ $? -eq 0 ]];then
      echo ${REVISION} > $DEP_REVISION
    fi
    ln -sfT $DEP_INSTALL $DEP_INSTALL_LATEST
  fi
  cd $APP_DIR
}
start_build_dep(){
  # skip same high gcc strict check warning
  # -Wno-error=class-memaccess fix gcc9 error: ‘void* memcpy(void*, const void*, size_t)’ writing to an object of a non-trivial type ... leaves 94 bytes 
  # -Wno-implicit-fallthrough  fix gcc9 warn:  error: this statement may fall through
  CFLAGS="-Wno-error=class-memaccess -Wno-implicit-fallthrough"

  CXXFLAGS=$CFLAGS build_pkg Tencent/rapidjson v1.1.0 2b05fabdc01e591a4f93af06aaf93aadefaed1b6 "-DRAPIDJSON_BUILD_TESTS=OFF -DRAPIDJSON_BUILD_DOC=OFF -DRAPIDJSON_BUILD_EXAMPLES=OFF -DCMAKE_BUILD_TYPE=Release"
  build_pkg jbeder/yaml-cpp yaml-cpp-0.7.0 56692e7132235d2ea8c414ee9f0787ddb8a1c9b9 "-DYAML_CPP_BUILD_TESTS=OFF"
  build_pkg microsoft/cpprestsdk v2.10.18 15f02e1e9acba260764b0dec1d712f235583d830 "-DCPPREST_EXCLUDE_WEBSOCKETS=ON"
}
