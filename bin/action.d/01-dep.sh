BASE_CMAKE_OPTS="-DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release"


build_protobuf(){
  local src=$1
  local dst=$2
  cd $src
  ./autogen.sh
  ./configure --prefix=$dst
  make -j$(nproc)
  make check
  make install
  cd $APP_DIR
}


build_pkg(){
  : ${REPO_TYPE:=git_tgz}
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

  log "build[$repo][$REVISION] " "30;46;01"

  mkdir -p $DEP_PKG $DEP_INSTALL $DEP_BUILD_DIR
  if [[ "$REPO_TYPE" != "git" ]];then
    mkdir -p $DEP_SRC
    # download pkg
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
  elif [[ "$REPO_TYPE" == "git" ]];then
    mkdir -p $DEP_SRC_DIR/$repo
    cd $DEP_SRC_DIR/$repo
    if [[ ! -d $DEP_SRC ]];then
      git clone https://github.com/$repo.git $REVISION
      cd $REVISION
      git checkout $REVISION
      git submodule update --init --recursive
    fi
  fi

  # build pkg
  local DEP_REVISION=$DEP_INSTALL/.revision
  if [[ ! -f $DEP_REVISION ]];then
    cd $DEP_BUILD_DIR
    local custom_fun="build_$name"
    if fun_exists $custom_fun;then
      eval $custom_fun $DEP_SRC $DEP_INSTALL
    else
      echo "cmake $BASE_CMAKE_OPTS -DCMAKE_INSTALL_PREFIX=$DEP_INSTALL $BUILD_OPTIONS $DEP_SRC"
      cmake $BASE_CMAKE_OPTS -DCMAKE_INSTALL_PREFIX=$DEP_INSTALL $BUILD_OPTIONS $DEP_SRC
      die_if_err "cmake fail"
      make -j$(nproc)
      die_if_err "make fail"
      make install
      die_if_err "make install fail"
    fi
    echo ${REVISION} > $DEP_REVISION
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
  REPO_TYPE=git build_pkg aws/aws-sdk-cpp 1.9.67 "-" "-DENABLE_TESTING=OFF -DBUILD_ONLY=s3"
  build_pkg gflags/gflags v2.2.2 5ad356c992ff690a2d030a3b23f83f9bce3e5df3 ""
  build_pkg protocolbuffers/protobuf v3.18.0 38cbb2075f3d0a482cec578d76311ea38580dd6d ""
  build_pkg google/glog v0.6.0 83a4b79dce5cedbffb66b09bb35b6d32f54f3897 "-DWITH_GTEST=OFF"
  build_pkg abseil/abseil-cpp 20230125.1 98c7002ec2aa2e5be8dcfe552e56d70fc64ecdec ""
  build_pkg madler/zlib v1.2.13 ebcdaa149fc44c609aeed848f76715b066e7b128 ""
  build_pkg google/googletest v1.13.0 db16834ccc7fcf49e1dc3319e0133f4c938ef95b ""
  build_pkg google/benchmark v1.7.1 eb283d4d64e7d5df2fee5439f9c21499f955cf31 "-DBENCHMARK_ENABLE_TESTING=OFF"
}

