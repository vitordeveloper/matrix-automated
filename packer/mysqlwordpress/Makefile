 .PHONY: all

all: config ami

REGION?=us-east-1
VERSION=$(shell cat VERSION)
# VPCID=$(shell terraform output|grep vpc_id|cut -d" " -f3)
# SUBNETID=$(shell terraform output private_subnet_id)
#DOCKER_PASSWD=$(shell cat .pass)
DEFAULT_AMI=ami-c481fad3


#vpc:
#	echo 'Creating VPC...'
#	$(MAKE) -C ../../terraform/aws/vpc/ all

# config:
#	# config vpc remote state
#	terraform remote config -backend=s3 -backend-config="bucket=m4u" -backend-config="key=plataformas/terraform/states/vpc-dev/vpc-dev.tfstate"
#	terraform remote pull

config:


ami:
	echo 'Executing packer...'
	packer build -var aws_region=${REGION} -var aws_ami=${DEFAULT_AMI} -var app_version=${VERSION} aws-mysql-wordpress.json


# destroy-vpc:
#	$(MAKE)	-C ../../terraform/aws/vpc/ destroy