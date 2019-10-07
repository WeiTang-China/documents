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
    read  -t 5 -n 1 -p "[WARN] this folder is NOT the root of git, keep running? [y/n]" choice
    echo ""
    if [ "$choice" != "" ] && [ "$choice" != "Y" ] && [ "$choice" != "y" ]
    then
        echo "cancel."
        exit -2
    fi
fi

# Helper
# ${string: start :length}	从 string 字符串的左边第 start 个字符开始，向右截取 length 个字符。
# ${string: start}	从 string 字符串的左边第 start 个字符开始截取，直到最后。
# ${string: 0-start :length}	从 string 字符串的右边第 start 个字符开始，向右截取 length 个字符。
# ${string: 0-start}	从 string 字符串的右边第 start 个字符开始截取，直到最后。
# ${string#*chars}	从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。
# ${string##*chars}	从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。
# ${string%*chars}	从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。
# ${string%%*chars}	从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。

CUR_BRANCH_SHOW_NAME=`git branch -vv | grep \* | awk '{print $2}'`

CUR_BRANCH=`git branch -vv | grep \* | awk '{print $4}'`
# 掐头去尾，去掉最外面的[]
CUR_BRANCH=${CUR_BRANCH:1:`expr ${#CUR_BRANCH}-2`}
# 第一个/左边的是remote名称，一般是origin
REMOTE_NAME=${CUR_BRANCH%%/*}
# 第一个/右边的内容，可能是"分支名: ahead 1, behind 4"
CUR_BRANCH=${CUR_BRANCH#*/}
# 第一个:左边的内容，最终取到分支名
CUR_BRANCH=${CUR_BRANCH%%:*}

# echo "REMOTE_NAME=$REMOTE_NAME; CUR_BRANCH=$CUR_BRANCH; CUR_BRANCH_SHOW_NAME=$CUR_BRANCH_SHOW_NAME;"

if [ "$1" != "" ] && [ "$1" != "$CUR_BRANCH" ] && [ "$1" != "$CUR_BRANCH_SHOW_NAME" ]
then
    INPUT_BRANCH=`git branch -vv | grep -w \$1 | awk '{print $3}'`
    echo "INPUT_BRANCH='$INPUT_BRANCH'"
    if [ "$INPUT_BRANCH" != "" ]
    then
        # 掐头去尾，去掉最外面的[]
        INPUT_BRANCH=${INPUT_BRANCH:1:`expr ${#INPUT_BRANCH}-2`}
        # 第一个/左边的是remote名称，一般是origin
        REMOTE_NAME=${INPUT_BRANCH%%/*}
        # 第一个/右边的内容，可能是"分支名: ahead 1, behind 4"
        INPUT_BRANCH=${INPUT_BRANCH#*/}
        # 第一个:左边的内容，最终取到分支名
        INPUT_BRANCH=${INPUT_BRANCH%%:*}
    else
        INPUT_BRANCH=$1
    fi

    echo "git fetch $REMOTE_NAME $INPUT_BRANCH"

    git fetch $REMOTE_NAME $INPUT_BRANCH
    if [ "$?" != "0" ]
    then
        exit -2
    fi
    # use $1 because local branch name maybe changed
    echo "git checkout $1"
    git checkout $1
    if [ "$?" != "0" ]
    then
        exit -3
    fi
    CUR_BRANCH=$INPUT_BRANCH
fi

echo "git pull -r $REMOTE_NAME $CUR_BRANCH"
git pull -r $REMOTE_NAME $CUR_BRANCH
