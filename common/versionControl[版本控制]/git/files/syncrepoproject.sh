#!/bin/bash

#[ "$1" == "" ] && echo "#ERROR# please input '<project ... />', copy it from version xml." && exit 101

PROJECT_XML=$1
while [ "$PROJECT_XML" == "" ]
do
    echo "copy/paste '<project ... />' from version.xml:"
    read PROJECT_XML
done

PROJECT_XML=$(echo $PROJECT_XML |grep -E "^<project .*/>$")

[ "$PROJECT_XML" == "" ] && echo "#ERROR# invalid format: $PROJECT_XML" && exit 102

echo "[INFO] PROJECT_XML=$PROJECT_XML"

FILE_PROJECT_XML_LINES=".`date +%s`.tmp"
echo $PROJECT_XML |awk '{print $2 "\n" $3 "\n" $4 "\n" $5 "\n" $6 "\n" $7}' > $FILE_PROJECT_XML_LINES

NAME=$(awk -F "\"" '$1 == "name="{print $2}' $FILE_PROJECT_XML_LINES)
REMOTE=$(awk -F "\"" '$1 == "remote="{print $2}' $FILE_PROJECT_XML_LINES)
REVISION=$(awk -F "\"" '$1 == "revision="{print $2}' $FILE_PROJECT_XML_LINES)
UPSTREAM=$(awk -F "\"" '$1 == "upstream="{print $2}' $FILE_PROJECT_XML_LINES)
rm $FILE_PROJECT_XML_LINES

case $REMOTE in
    "gerrit.odm") REMOTE="odm"
    ;;
    "gerrit.rom") REMOTE="rom"
    ;;
    "gerrit.q") REMOTE="q"
    ;;
    "gerrit.p") REMOTE="p"
    ;;
    "") REMOTE="main"
    ;;
    *) echo "#ERROR# UNKNOWN remote: $REMOTE"
    exit 103
    ;;
esac

[ "$NAME" == "" ] && echo "#ERROR# empty NAME!!!" && exit 104
[ "$REVISION" == "" ] && echo "#ERROR# empty REVISION!!!" && exit 105
[ "$UPSTREAM" == "" ] && echo "#ERROR# empty UPSTREAM!!!" && exit 106

echo "[INFO] NAME=$NAME"
echo "[INFO] REMOTE=$REMOTE"
echo "[INFO] REVISION=$REVISION"
echo "[INFO] UPSTREAM=$UPSTREAM"
echo " "

[ ! -e $REMOTE/$NAME ] && mkdir -p $REMOTE/$NAME

if [ ! -e $REMOTE/$NAME/.git ]; then
    [ "$REMOTE" == "main" ] && GERRIT_PREFIX= || GERRIT_PREFIX="$REMOTE."
    echo "[DEBUG] git clone ssh://tangwei1@gerrit.${GERRIT_PREFIX}scm.adc.com:29418/$NAME -b $UPSTREAM $REMOTE/$NAME"
    git clone ssh://tangwei1@gerrit.${GERRIT_PREFIX}scm.adc.com:29418/$NAME -b $UPSTREAM $REMOTE/$NAME
    [ "$?" != "0" ] && echo "#ERROR# fail to git clone" && exit 107
fi

cd $REMOTE/$NAME
echo "[DEBUG] clear local changes..."
git add . -A &>/dev/null
git reset --hard &>/dev/null
echo "[DEBUG] git pull -r"
git pull -r
echo "[DEBUG] git checkout $UPSTREAM"
git checkout $UPSTREAM
[ "$?" != "0" ] && echo "#ERROR# fail to git checkout" && exit 108
if [ "$REVISION" != "$UPSTREAM" ];
then
    echo "[DEBUG] git reset --hard $REVISION"
    git reset --hard $REVISION
    [ "$?" != "0" ] && echo "#ERROR# fail to git reset" && exit 109
fi

echo "****************************************************************"
echo $REMOTE/$NAME
echo SUCCESS, BYE!!!