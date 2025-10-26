#!/bin/bash
set -euo pipefail

create_s3_bucket(){

	region="ap-south-1"
	read -p "Enter the name of S3 Bucket: " name
	bucket_name="$name-$(date +%s)"

	echo "🗑️ creating S3 Bucket $bucket_name in region $region "
	
	#creating s3 bucket
	aws s3api create-bucket \
		--bucket $bucket_name \
		--region $region \
		--create-bucket-configuration LocationConstraint=$region
	
	if [ $? -eq 0 ];
	then
		echo "🗑️ Bucket $bucket_name created successfully..."
	else
		echo "❌ Failed to create S3 Bucket..."
	fi

	#Enabling S3 Bucket versioning 
	aws s3api put-bucket-versioning \
		--bucket $bucket_name \
		--versioning-configuration Status=Enabled
	
	echo "💥 Bucket Versioning Enabled..."
}

create_s3_bucket
