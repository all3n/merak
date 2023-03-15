DESC_build="build ${PROJECT}"
start_build(){
  CMAKE_DIRS=$(find $APP_DIR/deps/install -name cmake -type d|xargs -d "\n"|sed -e 's/ /;/g')
  mkdir -p $BUILD_DIR
  cd $BUILD_DIR
  # https://cmake.org/cmake/help/latest/variable/CMAKE_PREFIX_PATH.html
  cmake -DCMAKE_PREFIX_PATH=$CMAKE_DIRS $@ ..
  make -j$(nproc)
  cd $APP_DIR
}


start_clean(){
  if [[ -d $BUILD_DIR ]];then
    rm -rf $BUILD_DIR
  fi
}
