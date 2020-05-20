#!/bin/bash

THIS_DIR="$(dirname "$0")"
source $THIS_DIR/_inputs

# Get My IP Address
MY_PUBLIC_IP=$(curl -s https://checkip.amazonaws.com/)

aws --profile $AWS_PROFILE cloudformation \
create-stack --stack-name $CLOUDFORMATION_STACK_NAME \
--template-body file://infrastructure-template.yaml \
--parameters \
ParameterKey=UserData,ParameterValue=$(base64 user-data.sh) \
ParameterKey=VPCName,ParameterValue=$VPC_NAME \
ParameterKey=VPCCidr,ParameterValue=$VPC_CIDR \
ParameterKey=PublicSubnetCIDR,ParameterValue=$PUBLIC_SUBNET_CIDR \
ParameterKey=PublicSubnetAZ,ParameterValue=$PUBLIC_SUBNET_AZ \
ParameterKey=PublicSubnetName,ParameterValue=$PUBLIC_SUBNET_NAME \
ParameterKey=PublicSubnetRouteTableName,ParameterValue=$PUBLIC_SUBNET_ROUTE_TABLE_NAME \
ParameterKey=PrivateSubnet1CIDR,ParameterValue=$PRIVATE_SUBNET_1_CIDR \
ParameterKey=PrivateSubnet1AZ,ParameterValue=$PRIVATE_SUBNET_1_AZ \
ParameterKey=PrivateSubnet1Name,ParameterValue=$PRIVATE_SUBNET_1_NAME \
ParameterKey=PrivateSubnet2CIDR,ParameterValue=$PRIVATE_SUBNET_2_CIDR \
ParameterKey=PrivateSubnet2AZ,ParameterValue=$PRIVATE_SUBNET_2_AZ \
ParameterKey=PrivateSubnet2Name,ParameterValue=$PRIVATE_SUBNET_2_NAME \
ParameterKey=PrivateSubnetsRouteTableName,ParameterValue=$PRIVATE_SUBNETS_ROUTE_TABLE_NAME \
ParameterKey=DBSubnetGroupName,ParameterValue=$DB_SUBNET_GROUP_NAME \
ParameterKey=KeyPairName,ParameterValue=$KEY_PAIR_NAME \
ParameterKey=AMIImageID,ParameterValue=$AMI_IMAGE_ID \
ParameterKey=InstanceName,ParameterValue=$INSTANCE_NAME \
ParameterKey=MyIpAddress,ParameterValue=$MY_PUBLIC_IP \
ParameterKey=AppServerSecurityGroupName,ParameterValue=$APP_SERVER_SECURITY_GROUP_NAME \
ParameterKey=DBSecurityGroupName,ParameterValue=$DATABASE_SECURITY_GROUP_NAME \
ParameterKey=DBInstanceIdentifier,ParameterValue=$DB_INSTANCE_IDENTIFIER \
ParameterKey=DBMasterUsername,ParameterValue=$DB_MASTER_USERNAME \
ParameterKey=DBMasterPassword,ParameterValue=$DB_MASTER_PASSWORD \


# To delete a stack
# aws --profile $AWS_PROFILE cloudformation delete-stack --stack-name $CLOUDFORMATION_STACK_NAME
