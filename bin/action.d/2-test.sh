start_build_test(){
  start_build "-DENABLE_TESTING=ON"
}
start_test(){
  if [[ -d $BUILD_DIR ]];then
    $BUILD_DIR/${PROJECT}_tests
  fi
}
