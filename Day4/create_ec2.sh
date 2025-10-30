#!/bin/bash

set -euo pipefail


check_aws_cli(){

	if [ aws --version >dev/null 2>&1 ];
	then
		echo "✅ AWS CLI is installed..."
	else
		echo "❌ AWs CLI is not installed...."
		return 1
	fi
}
install_aws_cli(){

	echo "✅ Installing AWS CLI..."

	#Install required dependencies
	sudo apt install unzip curl -y
	
	#Download the AWS CLI v2 installer
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

	#Installing aws cli 
	sudo apt install unzip -y
	unzip awscliv2.zip

	sudo ./aws/install
	
	#checking version
	aws --version

	#configuring aws
	aws configure

	#cleanup
	rm -rf aws awscliv2.zip
	

}



create_ec2(){

	echo "🧩 Creating EC2 instance...."

	ami_id="ami-02d26659fd82cf299"
	instance_type="t3.micro"
	key_name="DemoKey"
	region="ap-south-1"
	security_group="sg-0c2d7db173752e0aa"
	
	read -p "✏️  Enter Instance name: " instance_name

	echo "🚀 Launching 🧩 EC2 instance in $region...."

	#Creating EC2 instance
	Instance_id=$(aws ec2 run-instances \
		--image-id $ami_id \
		--instance-type $instance_type \
		--key-name $key_name \
		--security-group-ids $security_group \
		--count 1 \
		--region $region \
		--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
		--query "Instances[0].InstanceId" \
		--output text)
	
	if [ -z "$Instance_id" ];
	then
		echo "❌ Failed to create EC2 instances..."
		exit 1
	fi
	echo "💥 EC2 instance created sucessfully..."
	
	echo "🆔 Instance Id: $Instance_id"

	echo "🕓 Waiting for EC2 instance to enter running state...."
	
	aws ec2 wait instance-running --instance-ids $Instance_id --region $region

	echo "🚀 Launched 🧩 EC2 instance sucessfully..."

	state=$(aws ec2 describe-instances \
		--instance-ids $Instance_id \
		--region $region \
		--query "Reservations[0].Instances[0].State.Name" \
		--output text)

	public_ip=$(aws ec2 describe-instances \
                --instance-ids $Instance_id \
                --region $region \
                --query "Reservations[0].Instances[0].Public.Ip.Address" \
                --output text)

	echo "================================== INSTANCES DETAILS ================================== "
	echo "🆔 Instance ID: $Instance_id"
	echo "💥 STATE:$state"
	echo "🌎 PUBLIC IP: $public_ip"
	echo "======================================================================================= "


}

if [ check_aws_cli -eq 1 ];
then
	install_aws_cli
fi

create_ec2


