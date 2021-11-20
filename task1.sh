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
    return $(id -u "$1" >/dev/null 2>&1)
}

# Function is checking directory exist
# get 1 params - <directory>
function isDirectoryExist {
    if [ -d "$1" ]; then
        return 0
    fi

    return 1
}

# Function is checking for have negative result and show error message
# get 2 params - <condition> and <message>
function showErrorIfFalse {
    if [ $# -ge 1 ] && [ $1 -gt 0 ]
    then
        echo "$2"
        echo "Exit"
        exit
    fi
}

#
# START
#

if [[ $EUID -ne 0 ]]; then
   showErrorIfFalse 1 "This script must be run as root" 
elif [ $# -ne 2 ]; then
    showErrorIfFalse 1 "No parameters found. Script take 2 params 'username' and 'directory'"
fi

isUserExist $1
showErrorIfFalse $? "User does not exist"

isDirectoryExist $2
showErrorIfFalse $? "Directory does not exist"

read -p "Are you really want change owner for directory '$(pwd)' and for all files inside? 'yes' or 'no': " ANSWER
if [ "$ANSWER" = "y" ] || [ "$ANSWER" = "yes" ]; then
    RESULT=$(chown -R $1 $2)
    showErrorIfFalse ${#RESULT} "$RESULT"
    ls -do $2
    echo "All done!"
fi