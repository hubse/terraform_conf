variable "aws_region" {
  description = "AWS region to launch resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI in us-east-1
}

variable "ssh_access_cidr" {
  description = "CIDR block allowed for SSH access (default: restricted to RFC1918 private networks)"
  type        = string
  default     = "10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
  validation {
    condition     = can([for cidr in split(",", var.ssh_access_cidr): cidrnetmask(trimspace(cidr))])
    error_message = "Must be a comma-separated list of valid CIDR blocks"
  }
}

variable "iam_policy_arns" {
  description = "List of IAM policy ARNs to attach to the EC2 instance role"
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"]
}
