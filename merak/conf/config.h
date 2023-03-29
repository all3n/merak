#pragma once
#include <vector>
#include <yaml-cpp/yaml.h>
namespace merak {
struct AppDep {
  std::string name;
  std::string repo;
  std::string type;
  std::string url;
  std::string build_options;
};
struct AppConfig {
  std::vector<AppDep> deps;
};
bool LoadConfig(AppConfig &cfg, const std::string &f);
} // namespace merak
