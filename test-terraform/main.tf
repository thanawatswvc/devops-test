provider "aws" {
    region = "ap-southeast-1"
  }
  
  # Create VPC
  resource "aws_vpc" "nodejs_vpc" {
    cidr_block = "10.0.0.0/16"
  }
  
  # Create application subnet
  resource "aws_subnet" "application_subnet" {
    vpc_id            = aws_vpc.nodejs_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
  }
  
  # Create security group for application instances
  resource "aws_security_group" "nodejs_app_security_group" {
    name_prefix = "nodejs_app_security_group"
    vpc_id      = aws_vpc.nodejs_vpc.id
    
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ingress {
        from_port   = 2003
        to_port     = 2003
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port   = 2004
        to_port     = 2004
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port   = 2023
        to_port     = 2023
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port   = 2024
        to_port     = 2024
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port   = 8125
        to_port     = 8125
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      ingress {
        from_port   = 8126
        to_port     = 8126
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
  }

  
  # Create EC2 instances
  resource "aws_instance" "app_instances" {
    count         = 2
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name      = "my-key"
    vpc_security_group_ids = [aws_security_group.nodejs_app_security_group.id]
    subnet_id     = aws_subnet.application_subnet.id
    
  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
    delete_on_termination = false  
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = "30"
    volume_type = "gp3"
    delete_on_termination = false
   }
  }
  
  # Create ALB load balancer
  resource "aws_alb" "nodejs_app_alb" {
    name            = "nodejs-app-alb"
    subnets         = [aws_subnet.application_subnet.id, aws_subnet.data_subnet.id]
    security_groups = [aws_security_group.nodejs_app_alb_security_group.id]
  }
  
  # Create security group for ALB
  resource "aws_security_group" "nodejs_app_alb_security_group" {
    name_prefix = "nodejs_app_alb_security_group"
    vpc_id      = aws_vpc.nodejs_vpc.id
    
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  # Create target group for ALB
  resource "aws_alb_target_group" "nodejs_app_target_group" {
    name        = "nodejs-app-target-group"
    port        = 80
    protocol    = "HTTP"
  }
