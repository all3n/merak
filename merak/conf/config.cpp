#include "merak/conf/config.h"
#include <ac/common/file_utils.h>
#include <glog/logging.h>

namespace YAML {
template <> struct convert<merak::AppDep> {
  static YAML::Node encode(const merak::AppDep &dep) {
    YAML::Node node;
    return node;
  }
  static bool decode(const YAML::Node &node, merak::AppDep &dep) {
    dep.name = node["name"].as<std::string>();
    dep.url = node["url"].as<std::string>();
    dep.repo = node["repo"].as<std::string>();
    dep.type = node["type"].as<std::string>();
    dep.build_options = node["build_options"].as<std::string>();
    return true;
  }
};
template <> struct convert<merak::AppConfig> {
  static YAML::Node encode(const merak::AppConfig &cfg) {
    YAML::Node node;
    // TODO
    return node;
  }
  static bool decode(const YAML::Node &node, merak::AppConfig &cfg) {
    LOG(INFO) <<"i decode";
    LOG(ERROR) <<"e decode";
    if(!node["deps"]){
      LOG(ERROR) << "deps not exists";
      return false;
    }
    auto &deps = node["deps"];
    for (auto it = deps.begin(); it != deps.end(); ++it) {
      std::string name = it->first.as<std::string>();
      auto dep = it->second.as<merak::AppDep>();
      cfg.deps.push_back(dep);
    }
    return true;
  }
};
} // namespace YAML

namespace merak {
bool LoadConfig(AppConfig &cfg, const std::string &f) {
  if(ac::common::file::exists(f)){
    //try{
      cfg = YAML::LoadFile(f).as<AppConfig>();
      return true;
    //}catch(const YAML::Exception &e){
    //  LOG(ERROR) << e.msg << ":" << e.what();
    //  return false;
    //}
  }else{
    LOG(ERROR) << f << " not exists";
    return false;
  }
}
} // namespace merak
