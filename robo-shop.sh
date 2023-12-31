#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0a3b85d108db5d5f9
INSTANCES=("mongodb" "redis" "rabbit mq" "catalogue" "user" "cart"
"mysql" "shipping" "payment" "dispatch" "web")
DOMAIN_TYPE=bhimarakesh.online
ZONE_ID=Z091493814PA0LK7HUQ95
for i in "${INSTANCES[@]}"
do
  echo "instance is: $i"
  if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
  then
  INSTANCE_TYPE="t3.small"
  else
  INSTANCE_TYPE="t2.micro"
  fi


 IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query Instances[0] PrivateIpAddress' --outputtext)

 aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
  {
    "Comment": "Creating a record set for cognito endpoint"
    ,"Changes": [{
      "Action"              : "CREATE"
      ,"ResourceRecordSet"  : {
        "Name"              : "'$i'.'$DOMAIN_TYPE'"
        ,"Type"             : "A"
        ,"TTL"              : 1
        ,"ResourceRecords"  : [{
            "Value"         : "'$IP_ADDRESS'"
        }]
      }
    }]
  }
done