#!/bin/bash
set -euo pipefail

create_ec2(){

	ami_id=" ami-02d26659fd82cf299"
	instance_type="t3.micro"
	key_name="DemoKey"
	security_group="sg-0c2d7db173752e0aa"
	region="ap-south-1"
	read -p "🧩 Enter Name for EC2 Instance: " instance_name

	#Creating EC2 Instance
	Instance_id=$(aws ec2 run-instances \
		--image-id $ami_id \
		--key-name $key_name \
		--instance-type $instance_type \
		--count 1 \
		--region $region \
		--security-group-ids  $security_group \
		--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
		--query "Instances[0].InstanceId" \
		--output text)
	
	if [ -z "$Instance_id" ];
	then
		echo "❌ Failedto create Instance...."
	fi
	echo "🎉 EC2 Instance created Sucessfully..."
	echo "🆔 Instance ID:$Instance_id"
	echo "🕒 Waiting for Instance enter into running state..."

	aws ec2 wait instance-running --instance-ids $Instance_id  --region $region
	
	echo "🚀 Instance Launcged sucessfully.."
	
	state=$(aws ec2 describe-instances \
		--instance-ids $Instance_id \
		--region $region \
		--query "Reservations[0].Instances[0].State.Name" \
		--output text)

	public_ip=$(aws ec2 describe-instances \
                --instance-ids $Instance_id \
                --region $region \
                --query "Reservations[0].Instances[0].PublicIpAddress" \
                --output text)

	echo "----------------------------------------------------------"
	echo "🆔 ID:$Instance_id"
	echo "💥 STATE: $state"
	echo "🌎 PUBLIC IP: $public_ip"
	echo "----------------------------------------------------------"

		
}

create_s3_bucket(){


	region="ap-south-1"
	read -p "💻 Enter namefor S3 Bucket: " name
	bucket_name="$name-$(date +%s)"
	echo "🗑️ Creating Bucket $bucket_name in region $region"

	#creating S3 Bucket
	aws s3api create-bucket \
		--bucket $bucket_name \
		--region $region \
		--create-bucket-configuration LocationConstraint=$region

	if [ $? -eq 0 ];
	then
		 echo "🗑️ Created Bucket $bucket_name in region $region"
	else
		 echo "❌ Failed to create S3 Bucket...."
	fi

	#Enabling Bucket Versioning
	aws s3api put-bucket-versioning \
		--bucket $bucket_name \
		--versioning-configuration Status=Enabled
	
       	echo "🎉 Versioning Enabled for bucket: $bucket_name"

}

create_rds(){

	read -p "✏️  Enter db instance identifier: " db_instance_identifier
	read -p "✏️  Enter db name: " db_name
	read -p "✏️  Enter username: " username
	read -p "✏️  Enter password: " password
	engine="mysql"
	region="ap-south-1"
	db_instance_class="db.t4g.micro"
	allocated_storage=20

	echo "🚀 Creating rds instance..."

	aws rds create-db-instance \
		--db-instance-identifier $db_instance_identifier \
		--db-instance-class $db_instance_class \
		--master-username $username \
		--master-user-password $password \
		--engine $engine \
		--allocated-storage $allocated_storage \
		--no-multi-az \
		--backup-retention-period 0 \
		--storage-type gp2 \
		--publicly-accessible \
		--port 3306 \
		--tags Key=Name.Value=$db_name

	if [ $? -eq 0 ];
	then
		echo "✅ AWS RDS instance created successully...."
	else
		echo "❌ Failed to create AWS RDS instance...."
		exit 1
	fi

}

check_istance_status(){

	read -p"✏️  re-enter value for db instance identifier: " db_instance_identifier 
	region="ap-south-1"

	echo "⏳ checking instance status..."
	aws rds wait db-instance-available \
		--db-instance-identifier $db_instance_identifier \
		--region $region \
	       	
	echo "🎉 Yourrds instance is available now."
	aws rds describe-db-instance \
		--db-instance-identifier $db_instance_identifier \
                --region $region \
		--query  "DBInstances[0].Endpoint.Address" \
		--output text 

}


echo "==============================================================="
echo " AWS RESOURCE CREATION SCRIPT "
echo "==============================================================="
echo "1.CREATE EC2 INSTANCE"
echo "2.CREATE S3 BUCKET"
echo "3CREATE RDS INSTANCE"
echo "4.EXIT"
echo "==============================================================="

read -p "Enter your choice (1/2/3/4): "  choice

case $choice in
	1)
		create_ec2
		;;
	2)
		create_s3_bucket
		;;
	3)
		create_rds
		check_istance_status
		;;

	4)
		echo "👋 Exiting..."
		exit 0
		;;
	*)
		echo "❌ Invalid choice Please select between 1,2,3 & 4"
		;;
esac

























