DESC_build="build ${PROJECT}"
start_build(){
  mkdir -p $BUILD_DIR
  cd $BUILD_DIR
  cmake ..
  make -j$(nproc)
  cd $APP_DIR
}
