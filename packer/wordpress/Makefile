 .PHONY: all

all: config ami

REGION?=us-east-1
VERSION=$(shell cat VERSION)
PROJECTNAME=${projectname}
DEFAULT_AMI=ami-c481fad3



config:


ami:
	echo 'Executing packer...'
	packer build -var aws_region=${REGION} -var project_name=${PROJECTNAME} -var aws_ami=${DEFAULT_AMI} -var app_version=${VERSION} aws-wordpress.json