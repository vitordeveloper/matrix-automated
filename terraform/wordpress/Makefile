.PHONY: all

REGION?=us-east-1
AWS_DEFAULT_REGION=${REGION}
aws_access_key
ENVIRONMENT=${enviroment}
PROJECT_NAME=${projectname}
TYPE=${instancetype}
VERSION=$(shell cat ../../packer/wordpress/VERSION)
KEYPAIR=$(shell cat keys/${PROJECT_NAME}.pub)
COUNT=${qnt}
PROJECT_AMI=$(shell aws ec2 describe-images --owners self --filters "Name=tag:Name,Values=${PROJECT_NAME}" "Name=tag:version,Values=${VERSION}" --query 'Images[].[ImageId]' --output text | grep -m5 "ami-")

all: config plan apply

config:
	#terraform remote config -backend-config=shared_credentials_file=${HOME}/.aws/creds-terraform-${ENVIRONMENT} -backend-config=region=${REGION} -backend-config=key=terraform/states/${PROJECT_NAME}/${PROJECT_NAME}.tfstate
	#
	if [ ! -d "keys/" ]; then \
	      mkdir keys; \
	fi
	if [ ! -f "keys/${PROJECT_NAME}" ]; then \
	     ssh-keygen -t rsa -N "" -f keys/${PROJECT_NAME}; \
	fi
	#
	echo "OK" > ./.config

plan:
	test -s .config || ( echo "Running make config first..."; make config; )
	terraform get -update
	terraform plan -var "aws_ami=${PROJECT_AMI}" -var "project_name2=${PROJECT_NAME}" -var "count=${COUNT}" -var "instance_type=${TYPE}" -var "keypair=${KEYPAIR}"   -var "region=${REGION}" -var "shared_credentials_file=${HOME}/.aws/creds-terraform-${ENVIRONMENT}"

apply:
	##if [ "$(ENVIRONMENT)" == "dev" ]; then \
	##    at now + 50 min -f ./autodestroy.sh; \
	##fi
	terraform apply -var "aws_ami=${PROJECT_AMI}" -var "project_name2=${PROJECT_NAME}" -var "count=${COUNT}" -var "instance_type=${TYPE}" -var "keypair=${KEYPAIR}"  -var "region=${REGION}" -var "shared_credentials_file=${HOME}/.aws/creds-terraform-${ENVIRONMENT}"

destroy:
	terraform destroy -var "aws_ami=$(PROJECT_AMI)" -var "project_name2=${PROJECT_NAME}" -var "count=${COUNT}" -var "instance_type=${TYPE}" -var "keypair=${KEYPAIR}"  -var "region=${REGION}" -var "shared_credentials_file=${HOME}/.aws/creds-terraform-${ENVIRONMENT}"  -force
	test -s .config && ( echo "Removing .config"; rm .config; ) || echo "No .config"
	rm -f /tmp/vpc.tfstate

graph:
	terraform graph | dot -Tpng > $(PROJECT_NAME)_graph.png

retry: destroy all

clean:
	rm -f ./.config
	rm -f terraform.tfstate.backup
	rm -f terraform.tfplan
	rm -f terraform.tfstate
	rm -fR .terraform/
	rm -f /tmp/vpc.tfstate
