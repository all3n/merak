#pragma once
#include "merak/actions/action.h"

namespace merak {
namespace actions {

class GetAction : public Action {
public:
  GetAction() {}
  ~GetAction() {}
  virtual void run();
};

} // namespace actions
} // namespace merak
