#!/bin/bash
set -euo 

install_aws_cli(){

	if [ aws --version >dev/null 2>&1 ];
	then
		echo "✅ AWS CLI is installed!"
	else
		echo "Installing AWS CLI..."

		#Install required dependencies
		sudo apt install unzip curl -y


		#Downloading the AWS CLI v2 installer

		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		#Unzip the installer
		unzip awscliv2.zip
		sudo ./aws/install
		
		aws --version

		#configuring aws
		aws configure

		rm -rf aws awscliv2.zip
	fi

}

install_aws_cli
