#!/bin/Bash


#for (( i=1; i<=5; i++ ));
#do
#	echo "creating folder demo$i..."
#	mkdir "demo$i"
#done

#print Even or Odd of user choice only in certain entered by user

read -p "What do you want to print Even or Odd enter your choice: " choice

read  -p "Enter the start of range: " strt

read  -p "Enter the end of range: " end

echo "Entered choice is $choice so printing all $choice from $start to $end"

for (( i=$strt; i<=$end; i++ ));
do
	if [[ $choice == "Even" && $(( $i%2)) -eq 0 ]]
	then
		echo "$i"
	elif [[ $choice == "Odd" && $(($i%2)) -ne 0 ]]
	then
		echo "$i"
	fi
done

num=0
echo "printing even numbers..."
while [ $num -le 10 ]
do
	if [ $(( num%2 )) -eq 0 ];
	then
		echo "$num"
	fi
	((num++))
done
