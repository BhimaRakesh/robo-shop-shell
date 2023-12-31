#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0a3b85d108db5d5f9
INSTANCES=("mongodb" "redis" "rabbit mq" "catalogue" "user" "cart"
"mysql" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
  echo "instance is: $i"
  if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
  then
  INSTANCE_TYPE="t3.small"
  else
  INSTANCE_TYPE="t2.micro"
  fi


 aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-0a3b85d108db5d5f9 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done