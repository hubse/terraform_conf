terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-instance-sg"
  description = "Allow SSH and HTTP traffic"
  tags = {
    Name        = "EC2-Security-Group"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_access_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name        = "EC2-Instance-Role"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_policies" {
  count      = length(var.iam_policy_arns)
  role       = aws_iam_role.ec2_role.name
  policy_arn = var.iam_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
  tags = {
    Name        = "EC2-Instance-Profile"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name        = "Terraform-EC2-Instance"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["LastModified"]
    ]
  }
}

