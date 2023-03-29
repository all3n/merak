#pragma once
#include <cstdlib>
#include <functional>
#include <glog/logging.h>
#include <memory>
#include <string>
#include <unordered_map>

namespace merak {
namespace actions {
class Action {
public:
  Action() {}
  // disable copy and assign
  Action(const Action &) = delete;
  Action &operator=(const Action &) = delete;
  static Action *Create(const std::string &name);
  virtual void run() = 0;
};

typedef Action *(*ActionCreator)();

class ActionRegister {
public:
  ActionRegister(std::string name, ActionCreator act_creator);
};

#define DEFINE_REGISTER_CREATOR(ACTION)                                        \
  Action *ACTION##_creator() { return (Action *)new ACTION(); }

#define REGISTER_ACTION(name, action)                                          \
  DEFINE_REGISTER_CREATOR(action)                                              \
  static ActionRegister const action_register_##name(#name, action##_creator);

} // namespace actions
} // namespace merak
