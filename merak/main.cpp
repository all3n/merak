#include <iostream>
#include <gflags/gflags.h>
#include <glog/logging.h>
#include "merak/actions/action.h"
#include "conf/config.h"

DEFINE_string(conf, "merak.yaml", "config path");

using namespace std;
using namespace merak::actions;
int main(int argc, char *argv[]){
  FLAGS_logtostderr = true;
  FLAGS_logtostdout = true;
  google::InitGoogleLogging(argv[0]);
  if(argc < 2){
    LOG(ERROR) << argv[0] << " action" << std::endl;
    return -1;
  }
  const char * action = argv[1];
  gflags::ParseCommandLineFlags(&argc, &argv, true);
  Action * ac = Action::Create(action);
  if(ac == nullptr){
    LOG(ERROR) << action << " not found";
    return -1;
  }
  merak::AppConfig cfg;
  if(!merak::LoadConfig(cfg, FLAGS_conf)){
    return -1;
  }
  std::unique_ptr<Action> pa(ac);
  pa->run();
  google::ShutdownGoogleLogging();
  return 0;
}
