variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "api_instance_type" {
  description = "EC2 type for API VM"
  type        = string
}

variable "inference_instance_type" {
  description = "EC2 type for inference VM"
  type        = string
}

variable "key_pair_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

variable "my_ip" {
  description = "Your public IP with /32 suffix"
  type        = string
}