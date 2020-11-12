#!/bin/bash

# defined const
FIXED_DIR=~/code
GERRIT_USER_NAME=tangwei1
DEFAULT_GERRIT_SERVER=

# parse params start
while getopts "d:" ARG
do
    case $ARG in
        d)
            echo "[INFO] set default gerrit server(used when remote is empty): $OPTARG"
            DEFAULT_GERRIT_SERVER=$OPTARG
            ;;
        ?)
            break;;
    esac
done

shift $((OPTIND-1))
ORIGIN_PROJECT_XML=$1
# parse params ended

while [ "$ORIGIN_PROJECT_XML" == "" ]
do
    echo "copy/paste '<project ... />' from version.xml:"
    read ORIGIN_PROJECT_XML
done

[ "$FIXED_DIR" != "" ] && cd $FIXED_DIR 

PROJECT_XML=$(echo $ORIGIN_PROJECT_XML |grep -E "^<project .*>$")

[ "$PROJECT_XML" == "" ] && echo "#ERROR# invalid format: $ORIGIN_PROJECT_XML" && exit 102

echo "[INFO] PROJECT_XML=$PROJECT_XML"

FILE_PROJECT_XML_LINES=".`date +%s`.tmp"
echo $PROJECT_XML |awk '{print $2 "\n" $3 "\n" $4 "\n" $5 "\n" $6 "\n" $7}' > $FILE_PROJECT_XML_LINES

NAME=$(awk -F "\"" '$1 == "name="{print $2}' $FILE_PROJECT_XML_LINES)
REMOTE=$(awk -F "\"" '$1 == "remote="{print $2}' $FILE_PROJECT_XML_LINES)
REVISION=$(awk -F "\"" '$1 == "revision="{print $2}' $FILE_PROJECT_XML_LINES)
UPSTREAM=$(awk -F "\"" '$1 == "upstream="{print $2}' $FILE_PROJECT_XML_LINES)
rm $FILE_PROJECT_XML_LINES

[ "$REMOTE" == "" ] && REMOTE=$DEFAULT_GERRIT_SERVER
case $REMOTE in
    "gerrit.odm") REMOTE="odm"
    ;;
    "gerrit.rom") REMOTE="rom"
    ;;
    "gerrit.q") REMOTE="q"
    ;;
    "gerrit.p") REMOTE="p"
    ;;
    "gerrit.realme.odm") REMOTE="realme.odm"
    ;;
    "") REMOTE="main"
    ;;
    *) echo "#ERROR# UNKNOWN remote: $REMOTE"
    exit 103
    ;;
esac

[ "$NAME" == "" ] && echo "#ERROR# empty NAME!!!" && exit 104
[ "$REVISION" == "" ] && echo "#ERROR# empty REVISION!!!" && exit 105

echo "[INFO] NAME=$NAME"
echo "[INFO] REMOTE=$REMOTE"
echo "[INFO] REVISION=$REVISION"
echo "[INFO] UPSTREAM=$UPSTREAM"
echo " "

# UPSTREAM can be empty, if empty, use REVISION
[ "$UPSTREAM" == "" ] && UPSTREAM=$REVISION 

[ ! -e $REMOTE/$NAME ] && mkdir -p $REMOTE/$NAME

if [ ! -e $REMOTE/$NAME/.git ]; then
    [ "$REMOTE" == "main" ] && GERRIT_PREFIX= || GERRIT_PREFIX="$REMOTE."
    echo "[DEBUG] git clone ssh://tangwei1@gerrit.${GERRIT_PREFIX}scm.adc.com:29418/$NAME -b $UPSTREAM $REMOTE/$NAME"
    git clone ssh://tangwei1@gerrit.${GERRIT_PREFIX}scm.adc.com:29418/$NAME -b $UPSTREAM $REMOTE/$NAME
    [ "$?" != "0" ] && echo "#ERROR# fail to git clone" && exit 107
fi

if [ ! -e $REMOTE/$NAME/.git/hooks/commit-msg ]; then
    scp -p -P 29418 tangwei1@gerrit.${GERRIT_PREFIX}scm.adc.com:hooks/commit-msg $REMOTE/$NAME/.git/hooks/
    [ "$?" != "0" ] && echo "[WARNING] fail to scp hooks"
fi

cd $REMOTE/$NAME
echo "[DEBUG] clear local changes..."
git add . -A &>/dev/null
git reset --hard &>/dev/null
echo "[DEBUG] git fetch origin $UPSTREAM"
git fetch origin $UPSTREAM
echo "[DEBUG] git checkout $UPSTREAM"
git checkout $UPSTREAM
#echo "[DEBUG] gitsync.sh $UPSTREAM"
#gitsync.sh $UPSTREAM
[ "$?" != "0" ] && echo "#ERROR# fail to git checkout" && exit 108
if [ "$REVISION" != "$UPSTREAM" ];
then
    echo "[DEBUG] git reset --hard $REVISION"
    git reset --hard $REVISION
    [ "$?" != "0" ] && echo "#ERROR# fail to git reset" && exit 109
else
    echo "[DEBUG] git reset --hard origin/$UPSTREAM"
    git reset --hard origin/$UPSTREAM
    [ "$?" != "0" ] && echo "#ERROR# fail to git pull" && exit 110
fi

echo "****************************************************************"
echo $FIXED_DIR/$REMOTE/$NAME
echo SUCCESS, BYE!!!
