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

CUR_BRANCH_SHOW_NAME=`git branch -vv | grep \* | awk '{print $2}'`

CUR_BRANCH=`git branch -vv | grep \* | awk '{print $4}'`
CUR_BRANCH=${CUR_BRANCH:1:`expr ${#CUR_BRANCH}-2`}

REMOTE_NAME=${CUR_BRANCH%/*}
CUR_BRANCH=${CUR_BRANCH##*/}

if [ "$1" != "" ] && [ "$1" != "$CUR_BRANCH" ] && [ "$1" != "$CUR_BRANCH_SHOW_NAME" ]
then
    INPUT_BRANCH=`git branch -vv | grep -w \$1 | awk '{print $3}'`
    echo "INPUT_BRANCH='$INPUT_BRANCH'"
    if [ "$INPUT_BRANCH" != "" ]
    then
        INPUT_BRANCH=${INPUT_BRANCH:1:`expr ${#INPUT_BRANCH}-2`}
        INPUT_BRANCH=${INPUT_BRANCH##*/}
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

if [ "$CUR_BRANCH" = "master" ]
then
    GIT_POOL=
    CUR_BRANCH=
fi

echo "git pull -r $REMOTE_NAME $CUR_BRANCH"
git pull -r $REMOTE_NAME $CUR_BRANCH
