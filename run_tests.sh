#!/bin/sh

 #Colours
red="\033[00;31m"
RED="\033[01;31m"

green="\033[00;32m"
GREEN="\033[01;32m"

yellow="\033[00;33m"
YELLOW="\033[01;33m"

blue="\033[00;34m"
BLUE="\033[01;34m"

purple="\033[00;35m"
PURPLE="\033[01;35m"

cyan="\033[00;36m"
CYAN="\033[01;36m"

white="\033[00;37m"
WHITE="\033[01;37m"

NC="\033[00m"

PROJECT=`php -r "echo dirname(realpath('$0'));"`
CHANGED_FILES_CMD=`git status --porcelain | sed s/^...// | grep \\\\.php`

phplint_command="php -l -d display_errors=0"
phpcsfixer_vendor_command="./vendor/bin/php-cs-fixer fix --config .php_cs.dist --verbose"
phpcs_vendor_command="./vendor/bin/phpcs"
phpmd_vendor_command="./vendor/bin/phpmd <files> text phpmd.xml.dist --suffixes php,phtml,php.dist"
phpcpd_vendor_command="./vendor/bin/phpcpd --exclude=vendor/ --progress ./"

tag_only_changed="${PURPLE}(only changed)${NC}"
tag_whole_project="${CYAN}(whole project)${NC}"


# Determine if a file list is passed

if [ "$#" -eq 1 ]
then
    oIFS=$IFS
    IFS='
    '
    CFILES="$1"
    IFS=$oIFS
fi
CFILES=${CFILES:-$CHANGED_FILES_CMD}


# Run php lint

if [ "$CFILES" != "" ]
then
    echo "${BLUE}Checking PHP Lint... ${tag_only_changed}"
    echo "${BLUE}-------------------------------${NC}"
    for FILE in $CFILES
    do
        $phplint_command $PROJECT/$FILE
        if [ $? != 0 ]
        then
            echo "${RED}********************"
            echo "${RED}*  Fix the error.  *"
            echo "${RED}********************"
            exit 1
        fi
        FILES="$FILES $PROJECT/$FILE"
    done
    echo ""
fi


# Run php-cs-fixer

if [ "$FILES" != "" ]
then
    echo "${BLUE}Running php-cs-fixer... ${tag_only_changed}"
    echo "${BLUE}-------------------------------${NC}"
    $phpcsfixer_vendor_command $FILES
    echo ""
fi


# Run PHP Code Sniffer

if [ "$FILES" != "" ]
then
    echo "${BLUE}Running Code Sniffer... ${tag_only_changed}"
    echo "${BLUE}-------------------------------${NC}"
    $phpcs_vendor_command $FILES
    if [ $? != 0 ]
    then
        echo "${RED}********************"
        echo "${RED}*  Fix the error.  *"
        echo "${RED}********************"
        exit 1
        # echo "Coding standards errors have been detected. Running phpcbf..."
        # ./bin/phpcbf --standard=PSR2 --encoding=utf-8 -n -p $FILES
        # git add $FILES
        # echo "Running Code Sniffer again..."
        # ./bin/phpcs --standard=PSR2 --encoding=utf-8 -n -p $FILES
        # echo "Coding standards errors have been detected. Running php-cs-fixer..."
        # ./vendor/bin/php-cs-fixer fix --verbose $FILES
        # git add $FILES
        # echo "Running Code Sniffer again..."
        # ./vendor/bin/phpcs $FILES
        # if [ $? != 0 ]
        # then
        #    echo "${RED}Errors found not fixable automatically."
        #    exit 1
        # fi
    fi
    echo ""
fi


# Run PHPMD
  
if [ "$FILES" != "" ]
then
    echo "${BLUE}Running PHPMD... ${tag_only_changed}"
    echo "${BLUE}-------------------------------${NC}"
    FILESCS="${FILES// /,}"
    FILESCS=${FILESCS:1}
    ${phpmd_vendor_command/<files>/$FILESCS}
    if [ $? != 0 ]
    then
        echo "${RED}********************"
        echo "${RED}*  Fix the error.  *"
        echo "${RED}********************"
        exit 1
    fi
    echo ""
fi


# Run PHPCPD

echo "${BLUE}Running PHPCPD... ${tag_whole_project}"
echo "${BLUE}-------------------------------${NC}"
$phpcpd_vendor_command
if [ $? != 0 ]
then
    echo "${RED}********************"
    echo "${RED}*  Fix the error.  *"
    echo "${RED}********************"
    exit 1
fi

echo ""

echo "${GREEN}****************"
echo "${GREEN}*  Well done.  *"
echo "${GREEN}****************"
echo "${NC}"

exit 0
