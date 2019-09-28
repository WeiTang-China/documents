#!/bin/bash

#check if git env
CUR_WORK_STATUS=`git branch 2>/dev/null`
if [ "$?" != "0" ]
then
    echo "`pwd` is not a valid git folder"
    exit -1
fi

GIT_PATH=`pwd`"/.git/config"

if ! [ -e $GIT_PATH ] && false
then
    read -n 1 -p "[WARN] this folder is NOT the root of git, keep running? [y/n]" choice
    echo ""
    if [ "$choice" != "" ] && [ "$choice" != "Y" ] && [ "$choice" != "y" ]
    then
        echo "cancel."
        exit -2
    fi
fi

while [ "$1" ]; do
    case "$1" in
        --force)
            FORCE_PUSH=" $1"
            ;;
        *)
            echo "[WARN] unknown param:$1"
            ;;
    esac
    shift
done

# Helper
# ${string: start :length}	从 string 字符串的左边第 start 个字符开始，向右截取 length 个字符。
# ${string: start}	从 string 字符串的左边第 start 个字符开始截取，直到最后。
# ${string: 0-start :length}	从 string 字符串的右边第 start 个字符开始，向右截取 length 个字符。
# ${string: 0-start}	从 string 字符串的右边第 start 个字符开始截取，直到最后。
# ${string#*chars}	从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。
# ${string##*chars}	从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。
# ${string%*chars}	从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。
# ${string%%*chars}	从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。

CUR_BRANCH=`git branch -vv | grep \* | awk '{print $4}'`
# 掐头去尾，去掉最外面的[]
CUR_BRANCH=${CUR_BRANCH:1:`expr ${#CUR_BRANCH}-2`}
# 第一个/左边的是remote名称，一般是origin
REMOTE_NAME=${CUR_BRANCH%%/*}
# 第一个/右边的内容，可能是"分支名: ahead 1, behind 4"
CUR_BRANCH=${CUR_BRANCH#*/}
# 第一个:左边的内容，最终取到分支名
CUR_BRANCH=${CUR_BRANCH%%:*}

PUSH_TYPE=`git config push.type`

# echo "REMOTE_NAME=$REMOTE_NAME; CUR_BRANCH=$CUR_BRANCH; DIRECT_PUSH=$DIRECT_PUSH;"

if [ "$PUSH_TYPE" = "" ] || [ "$PUSH_TYPE" = "direct" ]; then
    echo "git push $REMOTE_NAME $CUR_BRANCH"
    git push $REMOTE_NAME $CUR_BRANCH
elif [ "$PUSH_TYPE" = "gerrit" ]; then
    echo "git push $REMOTE_NAME HEAD:refs/for/$CUR_BRANCH"
    git push $REMOTE_NAME HEAD:refs/for/$CUR_BRANCH
elif [ "$PUSH_TYPE" = "tfs" ]; then
    read -p "Input your branch name: " self_defined_branch
    test -z "${self_defined_branch}"
    if [ -z "${self_defined_branch}" ] ; then
        echo "[Error] can't be empty"
        read -p "Input your branch name again: " self_defined_branch
        if [ -z "${self_defined_branch}" ] ; then
            echo "bye!"
            exit -3
        fi
    fi
    echo "git push$FORCE_PUSH $REMOTE_NAME $CUR_BRANCH:${self_defined_branch}"
    git push$FORCE_PUSH $REMOTE_NAME $CUR_BRANCH:${self_defined_branch}
else
    echo "UNKNOWN push.type=${PUSH_TYPE}!!!"
    echo "You can set push.type as below:"
    echo "  direct or unset - git put origin branch_name"
    echo "  gerrit - git put origin HEAD:refs/for/branch_name"
    echo "  tfs - git put origin branch_name:self_defined_branch"
    exit -4
fi