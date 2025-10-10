#!b/bin/bash

#Arguments Definition:n Bash scripting, arguments are values or parameters passed to a script when it is executed from the command line. These arguments allow scripts to be more flexible and reusable by taking dynamic input, rather than relying solely on hardcoded values or prompts within the script.

<<Syntax
    ./my_script.sh argument1 argument2 "argument with spaces"
Syntax


echo "Arguments passed by the Users are $1 $2"

addition=$(($1+$2))
substraction=$(($1-$2))
division=$(($2/$1))

echo "Addition of Arguments is $addition"
echo "Substraction of Arguments is $substraction"
echo "Division of Arguments is $division"

