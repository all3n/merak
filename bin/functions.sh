
function log() {
    if [ $# -ne 2 ];then
        COLOR="white"
    fi
    MSG=$1
    COLOR="$2"
    if [[ "$COLOR" == 'red' ]];then
       echo -e "\033[31m $MSG \033[0m"
    elif [[ "$COLOR" == 'green' ]];then
       echo -e "\033[32m $MSG \033[0m"
    elif [[ "$COLOR" == 'yellow' ]];then
       echo -e "\033[33m $MSG \033[0m"
    elif [[ "$COLOR" ==  'blue' ]];then
       echo -e "\033[34m $MSG \033[0m"
    else
       if [[ -n "$COLOR" ]];then
           echo -e "\033[${COLOR}m $MSG \033[0m"
       else
           echo -e "$MSG"
       fi
    fi
}
die_if_err(){
  local error=$?
  if (( error ));then
    log "$1" red
    exit
  fi
}

fun_exists(){
  type $1 > /dev/null 2>&1
}

has(){
    which $1 >/dev/null 2>&1
}
required(){
    has $1 || {
        echo "required $1"
        exit -1
    }
}
exec_hook(){
    local HOOK_NAME=$1
    local HOOK_FILE=$HOOKS_DIR/$HOOK_NAME.sh
    set -x
    if [[ -f $HOOK_FILE ]];then
	  echo "exec hook $HOOK_NAME"
        bash $HOOK_FILE
    fi
}

run_action(){
    local ACTION=$1
    local APP=$2
    if [[ "$ACTION" == "-h" ]];then
      ACTION=""
    fi

    FUNLIST=`typeset -f|grep -P -o "start_\w+\s+\(\)"|awk -F'start_' '{print $2}'|awk '{print $1}'|grep -v "^$"`
    if [[ -z "$ACTION" ]];then
        if [[ -n "$PROJECT_DESC" ]];then
          echo $PROJECT_DESC
        fi
        echo "ACTION LIST:"
        for FN in ${FUNLIST[@]};do
            VAR_DESC="DESC_$FN"
            printf "%20s\t%-30s\n" "$FN" "${!VAR_DESC}"
        done
        exit
    fi
    shift 1
    ACTIONS=`echo $ACTION|tr ',' ' '`
    
    for AN in ${ACTIONS[@]};do
        TSTART=$(date +%s)
        log "start $AN " "30;46;01"
        eval "start_$AN" $@
        TEND=$(date +%s)
        USE_TIME=$((TEND - TSTART))
        log "end   $AN ${USE_TIME}s" "30;42;01"
    done
}
