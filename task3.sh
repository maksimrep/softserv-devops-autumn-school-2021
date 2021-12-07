#!/bin/bash
# Repetskyi Maksym

# tree - №13

#   AAA
#   |--QAA
#   |--QDD
#   |   |--GR1
#   |   '--GR2
#   '--QBB

# 1) Cтворити bash скріпт який буде створювати дерево каталогів (Замість ААА вставити власне прізвище)
#    та 2 файли назви яких ім'я та прізвище, розширення .txt з вмістом номер групи та дата виконання завдання
#    і електронна пошта відповідно в підкаталогах.
# 2) Скопіювати за допомогою скріпта файли з каталогів в кореневий каталог
# 3) Перевірити за допомогою скріпта з регулярним виразом чи дійсно у файлі з іменем міститься електронна пошта.
# 4) Із файлу логів веб серверу Apache  знайти і вивести кількість та всі повідомлення про помилку 404
# Надати звіт з посиланням на скріпт та скріни виконаного завдання


# FUNCTIONS

# Function is checking directory exist
# get 1 params - <directory>
function isDirectoryExist {
    if [ -d "$1" ]; then
        return 0
    fi

    return 1
}

# Function is checking file exist
# get 1 params - <file>
function isFileExist {
    if [ -f "$1" ]; then
        return 0
    fi

    return 1
}

# Function is creating directory
# get 1 params - <path>
function createDirectory {
    return $(mkdir "$1" >/dev/null 2>&1)
}

# Function is creating file
# get 1 params - <file>
function createFile {
    return $(touch "$1" >/dev/null 2>&1)
}

# Function is writing data to the specified file and create directory if it not exist
# get 4 params - <file name> <group> <time> <email>
function writeData {
    if [ $# -ge 4 ];
    then
        echo -e "$2\n$3\n$4" > $1
    fi
}

# Function is searching files across set directory and move it to another directory
# get 2 params - <path> to <path>
function mvAllFileFromDirToDir() {
    if [ $# -lt 2 ]
    then
        return 1
    fi

    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            mvAllFileFromDirToDir $dir_or_file $2
        else
            moveFile $dir_or_file $2
            echo "was moved $dir_or_file to $2"
        fi  
    done
}

# Function is moving file to another place
# get 2 params - <path> to <path> 
function moveFile {
    if [ "$1" != "$2" ]
    then
        mv "$1" "$2"
    fi
}

# Function is checking for have negative result and show error message
# get 2 params - <condition> and <message>
function showErrorIfFalse {
    if [ $# -ge 3 ] && [ $1 -gt 0 ]
    then
        echo -e "$2"
    elif [ $# -ge 1 ] && [ $1 -gt 0 ]
    then
        echo -e "$2"
        echo "Exit"
        exit
    fi
}


# BEGIN

read -p "Enter name*: " NAME
read -p "Enter last name*: " LAST_NAME
read -p "Enter email*: " EMAIL

if [ -z "$NAME" ] || [ -z "$LAST_NAME" ] || [ -z "$EMAIL" ]; then
    showErrorIfFalse 1 "You should enter all data"
fi

FILL_IN="QDD"

END_PATH="$LAST_NAME/$FILL_IN"
FILES_ARRAY=("$END_PATH/$NAME.txt" "$END_PATH/$LAST_NAME.txt")


#################################################################
# TASK 1

echo -e "TASK 1 - Create directorys"

GROUP=312
DATE=$(date +"%T %d/%m/%y")
ARRAY=("$FILL_IN" "QAA" "QBB")

isDirectoryExist $LAST_NAME
if [ $? -ne 0 ]; then
    createDirectory $LAST_NAME
    showErrorIfFalse $? "Can't create directory $LAST_NAME"
fi

for ix in ${!ARRAY[*]}
do
    isDirectoryExist "$LAST_NAME/${ARRAY[$ix]}"
    if [ $? -ne 0 ]; then
        createDirectory "$LAST_NAME/${ARRAY[$ix]}"
        showErrorIfFalse $? "I can't create directory '$LAST_NAME'" 1
    fi
done

isDirectoryExist $END_PATH
showErrorIfFalse $? "Directory '$END_PATH' did't create"

for ix in ${!FILES_ARRAY[*]}
do
    createFile ${FILES_ARRAY[$ix]} 
    showErrorIfFalse $? "I can't create file ${FILES_ARRAY[$ix]}"
    writeData "${FILES_ARRAY[$ix]}" "$GROUP" "$DATE" "$EMAIL"
done

tree


#################################################################
# TASK 2

echo -e "\nTASK 2 - RELOCATE FILES"

mvAllFileFromDirToDir $LAST_NAME $LAST_NAME

tree


#################################################################
# TASK 3

echo -e "\nTASK 3 - FIND EMAIL"

REG_EMAIL='^[a-zA-Z0-9]\+@[a-zA-Z0-9]\+\.[a-z]\{2,\}'
RESULT=$(cat "$LAST_NAME/$NAME.txt" | grep "$REG_EMAIL")
if [ ${#RESULT} -gt 0 ]; then
    echo "File have email - $RESULT"
else
    echo "File $LAST_NAME/$NAME.txt did not have any email"
fi

tree

#################################################################
# TASK 4

echo -e "\nTASK 4 - SHOW ERRORS"

read -p "Enter a name of file: " FILE_NAME
isFileExist $FILE_NAME
showErrorIfFalse $? "File '$FILE_NAME' not find"

read -p "Enter text which need find: " FIND_TEXT
if [ -n "$FIND_TEXT" ]; then
    STRINGS=$(cat "$FILE_NAME" | grep -n "$FIND_TEXT")
    COUNT=$(cat "$FILE_NAME" | grep -c "$FIND_TEXT")
    showErrorIfFalse $COUNT "Was find $COUNT word(s) \n\n $STRINGS" 1
else
    showErrorIfFalse 1 "Cancelled"
fi

tree

echo "\nBy!"