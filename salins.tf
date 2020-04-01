provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

provider "ovh" {
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
  endpoint           = "ovh-eu"
}

resource "aws_security_group" "salins-security-group" {
  name = "${var.app_name}-${var.app_environment}-salins-security-group"
  description = "http, ssh"
  vpc_id = "vpc-5476162e"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-${var.app_environment}"
    Environment = var.app_environment
  }
}

resource "aws_eip" "aws-eip" {
  vpc = true
  tags = {
    Name = "${var.app_name}-${var.app_environment}-elastic-ip"
    Environment = var.app_environment
  }
}

resource "aws_instance" "salins" {
  ami = "ami-0fc61db8544a617ed"
  instance_type = "t2.micro"
  key_name = "salins"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.salins-security-group.id]
  tags = {
    Name = "${var.app_name}-${var.app_environment}"
    Environment = var.app_environment
  }
}

resource "aws_eip_association" "ec2-eip-association" {
  instance_id = aws_instance.salins.id
  allocation_id = aws_eip.aws-eip.id
}

output "public-ip-for-instance" {
  value = aws_eip.aws-eip.public_ip
}

resource "ovh_domain_zone_record" "aws" {
    zone = "salins.pl"
    subdomain = "aws"
    fieldtype = "A"
    ttl = "3600"	
    target = aws_eip.aws-eip.public_ip
}
