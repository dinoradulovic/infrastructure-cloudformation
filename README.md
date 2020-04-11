# AWS Backend APIs Infrastructure (Cloudformation)

This repo contains a cloudformation template and accompanying files to create the network infrastructure on AWS for deploying Backend APIs.
To see the same AWS Infrastructure setup using AWS CLI visit:
<https://github.com/dinoradulovic/infrastructure-scripts-aws-cli>


It creates a ***VPC*** with ***Public Subnet*** and ***two Private Subnets***. 

![aws architecture](https://github.com/dinoradulovic/infrastructure-scripts-aws-cli/blob/media/aws-architecture.png)

EC2 Instance is created inside the Public Subnet for the App Server to be deployed into. 
> It also runs the User data shell script that installs Node, PM2, Nginx and configures Nginx as a Reverse Proxy to pass the requests from port :80 to port :3000 where the App Server will be run.

RDS Instance is created inside the Private Subnets for the DB to be created inside.
RDS instance is accessible only from the EC2 instance, which you can use as Bastion Host to connect to DB. 

# Table of Contents 
* [Requirements](#requirements)
* [Configuration](#configuration)
* [Usage](#usage) 
	* [Creating Infrastructure](#creating-infrastructure ) 
	* [Reverting Infrastructure](#reverting-infrastructure) 

# Requirements

This repository assumes that you are working in a `Unix based environment` and that you have `AWS CLI v1` (tested with 1.16.68) configured with the named profile.

<https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html>
<https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html>

# Configuration

Set the required environment variables in ***_inputs*** file. 
```
CLOUDFORMATION_STACK_NAME=api-infrastructure
AWS_PROFILE="aws-user-profile"
AWS_REGION="ap-southeast-1"
VPC_NAME="my-cool-vpc"
VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_CIDR="10.0.0.0/24"
PUBLIC_SUBNET_AZ="ap-southeast-1a"
PUBLIC_SUBNET_NAME="public-subnet"
PUBLIC_SUBNET_ROUTE_TABLE_NAME="public-route-table"
PRIVATE_SUBNET_1_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_1_AZ="ap-southeast-1a"
PRIVATE_SUBNET_1_NAME="private-subnet-1"
PRIVATE_SUBNET_2_CIDR="10.0.2.0/24"
PRIVATE_SUBNET_2_AZ="ap-southeast-1b"
PRIVATE_SUBNET_2_NAME="private-subnet-2"
PRIVATE_SUBNETS_ROUTE_TABLE_NAME="private-route-table"
DB_SUBNET_GROUP_NAME="db-subnet-group"
KEY_PAIR_NAME="key-pair-name"
AMI_IMAGE_ID="ami-048a01c78f7bae4aa"
APP_SERVER_SECURITY_GROUP_NAME="app-server-security-group"
DATABASE_SECURITY_GROUP_NAME="db-security-group"
DB_INSTANCE_IDENTIFIER="my-cool-db-instance"
DB_MASTER_USERNAME="postgres"
DB_MASTER_PASSWORD="secret99"
```
> NOTE: _inputs file is committed as an example. If you use these scripts in your projects, don't commit these files. 

# Usage
## Creating Infrastructure

### ./stack-create.sh

This script creates a Cloudformation stack using AWS CLI.  
It uses **./infrastructure-template.yaml** to define and create a Cloudformation Stack Resources. 

> Make sure you place the private subnets in ***two different availability zones*** ([RDS requirement](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.WorkingWithRDSInstanceinaVPC.html#Overview.RDSVPC.Create)). 

On top of the network infrastructure, this template creates the EC2 and RDS instances and security groups for them.  
First security group is assigned to EC2 instance where the App Server will be deployed. It opens up a port 80 for everyone and port 22 for your local IP address.  
Second security group is assigned to RDS instance where the Database is created. It opens up port 5432 (PostgreSQL) for EC2 instance only. App Server can access the data from the database and this EC2 instance also serves as a bastion host.

***Template Outputs:***
- EC2 Instance PublicIp
- EC2 Instance Security Group ID
- Database Hostname
- Database Security Group ID

## Reverting Infrastructure
In order to delete all the resources, just run: 
`aws --profile your-aws-profile cloudformation delete-stack --stack-name your-cfn-stack-name`

