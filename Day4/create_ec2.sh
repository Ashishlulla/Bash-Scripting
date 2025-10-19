#!/bin/bash
set -euo pipefail


check_aws_cli(){
	
	if ! aws --version >/dev/null 2>&1;
	then
		echo "AWS CLI is not installed.Please install it first!!!"
		exit 1
	fi
}

install_aws_cli(){
	
	echo "Installing AWS CLI v2 on Linux "
	
	#Downloading AWS CLI v2 installer
	curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    	sudo apt-get install -y unzip &> /dev/null
    	unzip -q awscliv2.zip
    	sudo ./aws/install

    	# Verify installation
    	aws --version

    	# Clean up
    	rm -rf awscliv2.zip ./aws
}


create_ec2(){

	echo " ☁️ 💻 Creating EC2 instance..."

	read -p "➡️  Enter AMI ID: " ami_id
	read -p "➡️  Enter Instance Type: " instance_type
	read -p "➡️  Enter Key Name: " key_name
	read -p "➡️  Enter security group: " security_group
	read -p "➡️  Enter Instance Name: " instance_name
	read -p "➡️  Enter the Region:  " region
	#Create the EC2 Instance
	
	Instance_Id=$(aws ec2 run-instances \
		--image-id $ami_id \
		--instance-type $instance_type \
		--key-name $key_name \
		--security-group-ids $security_group \
		--count 1 \
		--region $region \
		--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
		--query 'Instances[0].InstanceId' \
	        --output text
		)
		if [ -z "$Instance_Id" ];
		then
			echo " ❌ Failed to create EC2 Instance..."
			exit 1
		fi

		echo " 🚀 EC2 Instance created Sucessfully ✅"
		echo " 🆔  Instance Id:$Instance_Id"

		aws ec2 wait instance-running --instance-ids $Instance_Id --region $region  
		echo "Instance in now running..."
		Public_ip=$(aws ec2 describe-instances \
			--instance-ids $Instance_Id \
			--region $region \
			--query "Reservations[0].Instances[0].PublicIpAddress" \
			--output text
		)
		echo "🌐 Public IP Address: $Public_ip"
		echo ""
		echo "🎉 EC2 instance '$instance_name' launched successfully in region '$region'!"	

}
if check_aws_cli; then
    echo "🎉 Skipping installation — AWS CLI is ready to use!"
else
    echo "⚙️  Installing AWS CLI now..."
    install_aws_cli
fi

create_ec2
