#include "merak/actions/action.h"
#include "action.h"

namespace merak {
namespace actions {

std::unordered_map<std::string, ActionCreator> action_creators;

Action *Action::Create(const std::string &name) {
  auto it = action_creators.find(name);
  if (it != action_creators.end()) {
    Action *na = it->second();
    return na;
  }
  return nullptr;
}

ActionRegister::ActionRegister(std::string name, ActionCreator act_creator) {
  auto it = action_creators.find(name);
  if (it == action_creators.end()) {
    action_creators[name] = act_creator;
  } else {
    LOG(ERROR) << name << " already register";
    exit(EXIT_FAILURE);
  }
}

} // namespace actions
} // namespace merak
