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

create_s3(){

	region="ap-south-1"
	read -p "Enter name for S3 bucket: " name
	bucket_name="$name-$(date +%s)"

	echo "🗑️ Creating S3 Bucket $bucket_name in 📍 region $region......"
	aws s3api create-bucket \
		--bucket $bucket_name \
		--region $region \
		--create-bucket-configuration LocationConstraint="$region"

	echo "🗑️ S3 Bucket Created Successfully...."

	aws s3api put-bucket-versioning \
		--bucket $bucket_name \
		--region $region \
		--versioning-configuration Status=Enabled

	echo "🎉 Versioning Enabled for bucket: $bucket_name"


}

if [ check_aws_cli -eq 1 ];
then
        install_aws_cli
fi

create_s3
