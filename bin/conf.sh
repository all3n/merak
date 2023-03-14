export PROJECT=merak
export HOOKS_DIR=$APP_DIR/hooks.d
export PROJECT_DESC=$(cat << EOF
 ${PROJECT} is utility tool for cpp
EOF
)
if [[ "$DEBUG" == "true" ]];then
  set -x
fi



export BUILD_DIR=$APP_DIR/build
export BIN=$BUILD_DIR/merak

export DEP_DIR=$APP_DIR/deps
export DEP_PKG_DIR=$DEP_DIR/pkg
export DEP_SRC_DIR=$DEP_DIR/src
export DEP_INSTALL_DIR=$DEP_DIR/install

. $APP_DIR/bin/functions.sh

for ACTION_SH in $(ls $APP_DIR/bin/action.d/*.sh|sort);do
  . $ACTION_SH
done

# this option only use dev mode
if [[ -f $APP_DIR/dev.env.sh ]];then
   source $APP_DIR/dev.env.sh
fi

