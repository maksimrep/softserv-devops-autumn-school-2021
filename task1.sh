#!/bin/bash
#
# SoftServ DevOps Autumn School 2021
#
# Bash (Task 1)
# https://docs.google.com/document/d/1VC8S0aYAFk_GECu6n4Thg5tLrHPyH4YjFjYlN-8ch44/edit
#
# Title: Create scenario to change the owner of files and folders
# Parameters: 
# $1 <username>
# $2 <directory>
#
# Requirements:
# $1 - should be existing user in your OS (in your script the checking block should be present)
#
# $2 - should be only the directory (also need to be checked in your script)

#
# FUNCTIONS
#

# Function is checking user exist
# get 1 params - <username>
function isUserExist {
    if [ $# -eq 1 ] && id "$1" >/dev/null 2>&1
    then
        return 1
    fi

    return 0
}

# Function is checking directory exist
# get 1 params - <directory>
function isDirectoryExist {
    if [ $# -eq 1 ] && [ -d $1 ]
    then
        return 1
    fi

    return 0
}

# Function is checking for have negative result and show error message
# get 2 params - <condition> and <message>
function showErrorIfFalse {
    if [ $# -ge 1 ] && [ $1 -eq 0 ]
    then
        echo "$2"
        exit
    fi
}

#
# START
#

if [[ $EUID -ne 0 ]]
then
   showErrorIfFalse 0 "This script must be run as root" 
elif [ $# -ne 2 ]
then
    showErrorIfFalse 0 "No parameters found. Script take 2 params 'username' and 'directory'"
fi

isUserExist $1
showErrorIfFalse $? "User does not exist"

isDirectoryExist $2
showErrorIfFalse $? "Directory does not exist"

RESULT=$(chown -R $1 $2)
if [ -n "$RESULT" ]
then
    echo "$RESULT"
else
    ls -do $2
    echo "All done!"
fi
