#!/bin/bash

#GIT_CLONE="git clone https://github.com/mentorchita/example-app-nodejs-backend-react-frontend"
#FOLDER="example-app-nodejs-backend-react-frontend"
#${GIT_CLONE}
#cd $FOLDER

# FUNCTIONS

# Function is checking directory exist
# get 1 params - <directory>
isDirectoryExist() {
    if [ -d "$1" ]; then
        return 0
    fi

    return 1
}

# Function mesuare time wich run
# get 1 params - <strin commands>
script_time() {
    echo $(time -f %E bash -c "bash -c \"$1\" &>/dev/null" 2>&1)
}

#BEGIN

echo "Task was runned!"

NPM_TIME=$(script_time "npm install && npm run build")
echo "NPM time: $NPM_TIME"

isDirectoryExist "./node_modules"
if [ -d "$?" ]; then
    rm -rf "./node_modules"
fi

isDirectoryExist "./static"
if [ -d "$?" ]; then
    rm -rf "./static"
fi

YARN_TIME=$(script_time "yarn install && yarn run build")
echo "YARN time: $YARN_TIME"

echo "END"
