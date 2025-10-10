#!/bin/bash


read -p "Enter the number: " num

if (( $num%2==0 ))
then
	echo "$num is Even!!!"
else
	echo "$num is Odd!!!"
fi


#print greatest of three from given Arguments
#
echo "printing the greatest of three from given Arguments..."
if [[ $1 -gt $2 && $2 -gt $3 ]]
then
	echo "$1 is greatest!!!"
elif [[ $1 -lt $2 && $2 -gt $3 ]]
then
	echo "$2 is greatest !!!"
else
	echo "$3 is greatest!!1"
fi
