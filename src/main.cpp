#include <iostream>
#include <gflags/gflags.h>
#include <glog/logging.h>

DEFINE_string(conf, "merak.yaml", "config path");

using namespace std;
int main(int argc, char *argv[]){
  google::InitGoogleLogging(argv[0]);
  if(argc < 2){
    LOG(ERROR) << argv[0] << " action" << std::endl;
    return -1;
  }
  const char * action = argv[1];
  gflags::ParseCommandLineFlags(&argc, &argv, true);
  return 0;
}
