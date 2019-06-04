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

CUR_BRANCH=`git branch -vv | grep \* | awk '{print $4}'`
CUR_BRANCH=${CUR_BRANCH:1:`expr ${#CUR_BRANCH}-2`}

REMOTE_NAME=${CUR_BRANCH%/*}
CUR_BRANCH=${CUR_BRANCH##*/}

if [ "$CUR_BRANCH" = "master" ]
then
    GIT_POOL=
    CUR_BRANCH=
fi

echo "git push $REMOTE_NAME HEAD:refs/for/$CUR_BRANCH"

git push $REMOTE_NAME HEAD:refs/for/$CUR_BRANCH
