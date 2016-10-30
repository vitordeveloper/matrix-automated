/*
 * Variables
 */
//variable "env" { }
//variable "domain" { }
//variable "dns_zone_id" { }
variable "aws_mysqlwordpress_ami" { }
variable "region" { }
variable "project_name2" { }
//variable "vpc_id" { }
//variable "subnet_a_app_id" { }
//variable "subnet_c_app_id" { }
variable "shared_credentials_file" { }
variable "keypair" { }
variable "instance_type" {default = "t2.micro"}
//variable "app_private_ips" { }


/*
 * AWS Provider
 */
provider "aws" {
    region = "${var.region}"
    shared_credentials_file  = "${var.shared_credentials_file}"
}

/*
 * Modules
 */





resource "aws_iam_role" "mysqlwordpress_iam_role" {
    name = "mysqlwordpress_iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "mysqlwordpress_instance_profile" {
    name = "mysqlwordpress_instance_profile"
	roles = ["mysqlwordpress_iam_role"]		}




resource "aws_iam_role_policy" "mysqlwordpress_iam_role_policy" {
    name = "mysqlwordpress_iam_role_policy"
    role ="${aws_iam_role.mysqlwordpress_iam_role.id}"
    policy =     <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DescribeLoadBalancers"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}


/*
 * Instances
 */
resource "aws_instance" "app" {
//    source = "modules/instances"
//    env = "${var.env}"
//    domain = "${var.domain}"
    ami = "${var.aws_mysqlwordpress_ami}"
//    instance_availability_zones = "${var.region}a, ${var.region}c"
    instance_type = "${var.instance_type}"
//    project_name = "${var.project_name2}"
    key_name = "${var.project_name2}"
    vpc_security_group_ids  =["${aws_security_group.sg_app.id}"]
//    instance_profile_name = "profile_plataformas"
//    app_private_ips = "${var.app_private_ips}"
//    subnet_ids = "${var.subnet_a_app_id}, ${var.subnet_c_app_id}"
//    subnet_id = "${element(split(",",var.subnet_ids), count.index)}"
//    ami = "${var.aws_app_ami}"
//    private_ip = "${element(split(",",var.app_private_ips), count.index)}"
    associate_public_ip_address = true
    iam_instance_profile = "${aws_iam_instance_profile.mysqlwordpress_instance_profile.id}"
    monitoring = true
    tags = {
             "Name" = "${var.project_name2}0${count.index + 1}"
             "project" = "${var.project_name2}"
             "sshUser" = "ec2-user"
    }


}


resource "aws_key_pair" "deployer" {
  key_name = "mysqlwordpress"
  public_key = "${var.keypair}"
}

/*
 * Security Group
 */
resource "aws_security_group" "sg_app" {
        name = "sg_app_${var.project_name2}"
        description = "ingress SSH 8080 and egress all"

        ingress {
               from_port = 0
               to_port = 0
               protocol = -1
               cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
               from_port = 0
               to_port = 0
               protocol = -1
               cidr_blocks = ["0.0.0.0/0"]
        }

}

resource "aws_route53_zone" "mysqldb" {
  name = "mysqldb"
  vpc_id = "${aws_security_group.sg_app.vpc_id}"
}

resource "aws_route53_record" "dbinstance" {
    // same number of records as instances
    zone_id = "${aws_route53_zone.mysqldb.zone_id}"
    name = "dbwordpress"
    type = "A"
    ttl = "300"
    records = ["${join("  ",aws_instance.app.*.private_ip)}"]
}

/*
 * KeyPair
 */
//resource "aws_key_pair" "kp-deployer" {
//    key_name = "${var.project_name}"
//    public_key = "${file(\"keys/${var.project_name}.pub\")}"
//}


/*
 * Output
 */
output "region" {
    value = "${var.region}"
}

//output "app_sg_id" {
//    value = "${aws_security_group.sg_app.id}"
//}

//output "instances_ips" {
//    value = "${module.instances.instances_ips}"
//}

output "instance_type" {
    value = "${var.instance_type}"
}

output "instances_ips" {
    value = "${join("  ",aws_instance.app.*.private_ip)}"
}

output "vpc_ids" {
    value = "${join("  ",aws_security_group.sg_app.*.vpc_id)}"
}

//output "instance_profiles" {
//    value = "${join("  ",aws_instance.app.*.iam_instance_profile)}"
//}
//output "subnet_app_c_id" {
//    value = "${var.subnet_a_app_id}"
//}
//
//output "subnet_app_a_id" {
//    value = "${var.subnet_c_app_id}"
//}