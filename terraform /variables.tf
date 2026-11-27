
variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "python-calculator"
}

variable "allowed_cidr" {
  description = "Your public IP address in CIDR format"
  type        = string
}

variable "key_pair_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

