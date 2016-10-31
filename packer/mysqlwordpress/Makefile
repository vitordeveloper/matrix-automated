 .PHONY: all

all: config ami

REGION?=us-east-1
VERSION=$(shell cat VERSION)
DEFAULT_AMI=ami-c481fad3


config:


ami:
	echo 'Executing packer...'
	packer build -var aws_region=${REGION} -var aws_ami=${DEFAULT_AMI} -var app_version=${VERSION} aws-mysql-wordpress.json
