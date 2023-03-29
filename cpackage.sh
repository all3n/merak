build_dep(){

  #local repo="$1"
  #local REVISION="$2"
  #local SHA1="$3"
  #local BUILD_OPTIONS="$4"
  
  # skip same high gcc strict check warning
  # -Wno-error=class-memaccess fix gcc9 error: ‘void* memcpy(void*, const void*, size_t)’ writing to an object of a non-trivial type ... leaves 94 bytes 
  # -Wno-implicit-fallthrough  fix gcc9 warn:  error: this statement may fall through
  CFLAGS="-Wno-error=class-memaccess -Wno-implicit-fallthrough"
  build_pkg CXXFLAGS="$CFLAGS" repo=Tencent/rapidjson REVISION=v1.1.0 SHA1=2b05fabdc01e591a4f93af06aaf93aadefaed1b6 \
    BUILD_OPTIONS="-DRAPIDJSON_BUILD_TESTS=OFF -DRAPIDJSON_BUILD_DOC=OFF -DRAPIDJSON_BUILD_EXAMPLES=OFF -DCMAKE_BUILD_TYPE=Release"
  build_pkg repo=jbeder/yaml-cpp REVISION=yaml-cpp-0.7.0 SHA1=56692e7132235d2ea8c414ee9f0787ddb8a1c9b9 BUILD_OPTIONS="-DYAML_CPP_BUILD_TESTS=OFF"
  build_pkg repo=gflags/gflags REVISION=v2.2.2 SHA1=5ad356c992ff690a2d030a3b23f83f9bce3e5df3 
  build_pkg repo=google/glog REVISION=v0.6.0 SHA1=83a4b79dce5cedbffb66b09bb35b6d32f54f3897 BUILD_OPTIONS="-DWITH_GTEST=OFF"
  build_pkg repo=abseil/abseil-cpp REVISION=20230125.1 SHA1=98c7002ec2aa2e5be8dcfe552e56d70fc64ecdec 
  build_pkg repo=madler/zlib REVISION=v1.2.13 SHA1=ebcdaa149fc44c609aeed848f76715b066e7b128
  build_pkg repo=google/googletest REVISION=v1.13.0 SHA1=db16834ccc7fcf49e1dc3319e0133f4c938ef95b
  build_pkg repo=google/benchmark REVISION=v1.7.1 SHA1=eb283d4d64e7d5df2fee5439f9c21499f955cf31 BUILD_OPTIONS="-DBENCHMARK_ENABLE_TESTING=OFF"
  build_pkg repo=protocolbuffers/protobuf REVISION=v3.18.0 SHA1=38cbb2075f3d0a482cec578d76311ea38580dd6d
  build_pkg repo=bombela/backward-cpp REVISION=v1.6 
  build_pkg repo=apache/brpc REVISION=1.4.0 BUILD_OPTIONS="-DProtobuf_INCLUDE_DIR=$DEP_INSTALL_DIR/protocolbuffers/protobuf/latest/include"
  #build_pkg repo=boost
}
