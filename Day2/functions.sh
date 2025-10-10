#!/bin/bash

# Function in Bash Scripting

#Function definition
even_odd(){
	num=$1
	if (( num%2==0 ))
	then
		echo "$num is Even!!!"
	else
		echo "$num is Odd!!!"
	fi
}
#Taking Input from user:
read -p "Enter the number to check if it is even or odd: " num
#Function Calling
even_odd $num
