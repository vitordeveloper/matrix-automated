/*
 * Variables
 */

variable "aws_ami" { }
variable "region" { }
variable "project_name2" { }
variable "shared_credentials_file" { }
variable "instance_type" { }
variable "keypair" { }
variable "count" { }




/*
 * AWS Provider
 */
provider "aws" {
    region = "${var.region}"
    shared_credentials_file  = "${var.shared_credentials_file}"
}


resource "aws_iam_role" "wordpress_iam_role" {
    name = "wordpress_iam_role"
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

resource "aws_iam_instance_profile" "wordpress_instance_profile" {
    name = "wordpress_instance_profile"
	roles = ["wordpress_iam_role"]		}

resource "aws_iam_role_policy" "wordpress_iam_role_policy" {
    name = "wordpress_iam_role_policy"
    role ="${aws_iam_role.wordpress_iam_role.id}"
    policy =     <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

/*
 * Instances
 */
resource "aws_instance" "app" {
    count = "${var.count}"
    ami = "${var.aws_ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.project_name2}"
    vpc_security_group_ids  =["${aws_security_group.sg_app.id}"]
    associate_public_ip_address = true
    iam_instance_profile = "${aws_iam_instance_profile.wordpress_instance_profile.id}"
    monitoring = true
    tags = {
             "Name" = "${var.project_name2}0${count.index + 1}"
             "project" = "${var.project_name2}"
             "sshUser" = "ec2-user"
    }


}

resource "aws_key_pair" "deployer" {
  key_name = "${var.project_name2}"
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


resource "aws_elb" "loadbalancerwordpress" {
  name = "wordpress-terraform-elb"
  availability_zones = ["us-east-1b", "us-east-1c", "us-east-1d","us-east-1e"]


  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }


  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8000/wp-login.php"
    interval = 30
  }

  instances = ["${aws_instance.app.*.id}"]
  cross_zone_load_balancing = false
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  tags {
    Name = "wordpress-terraform-elb"
  }
}


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

output "instance_profiles" {
    value = "${join("  ",aws_instance.app.*.iam_instance_profile)}"
}

output "instance_ids" {
    value = "${join("  ",aws_instance.app.*.id)}"
}


//output "subnet_app_c_id" {
//    value = "${var.subnet_a_app_id}"
//}
//
//output "subnet_app_a_id" {
//    value = "${var.subnet_c_app_id}"
//}