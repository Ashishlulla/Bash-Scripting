#!/bin/bash
set -euo pipefail

create_rds_instance(){

	read -p "✏️ Enter db_instance_identifier: " db_instance_identifier
	read -p "✏️ Enter db_name:  " db_name
	read -p "✏️ Enter username: " username
	read -p "✏️ Enter password: " password 
	instance_class="db.t4g.micro"
	allocated_storage=20
	engine="mysql"
	region="ap-south-1"
	
	echo "🚀 Creating AWS RDS instance..."
	aws rds create-db-instance \
		--db-instance-identifier $db_instance_identifier \
		--db-instance-class $instance_class \
		--master-username $username \
		--master-user-password $password \
		--engine $engine \
		--allocated-storage $allocated_storage \
		--region $region \
		--backup-retention-period 0 \
		--no-multi-az \
		--storage-type gp2 \
		--port 3305 \
		--tags Key=Name,Value=db_name
	
	if [ $? -eq 0 ]; then
      		  echo "✅ RDS instance creation initiated successfully!"
    	else
        	echo "❌ Failed to create RDS instance."
        	exit 1
    	fi

	echo "⏳ Checking DB instance available..."
	aws rds db-instance-available \
		--db-instance-identifier $db_instance_identifier \
		--region $region
	
	echo "✅ Your RDS instance is now available!"

	aws rds describe-instance \
		--db-instance-identifier $db_instance_identifier \
		--region $region \
		--query "DBInstances[0].Endpoint.Address" \
		--output text


}

create_rds_instance

