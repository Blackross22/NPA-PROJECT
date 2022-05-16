##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {
    type        = string
    description = "AWS Access Key"
    sensitive   = true
}
variable "aws_secret_key" {
    type        = string
    description = "AWS Secret Key"
    sensitive   = true
}
variable "aws_session_token" {
    type        = string
    description = "AWS Session Token"
    sensitive   = true
}
variable "private_key_path" {
    type        = string
    description = "Private key path"
    sensitive   = true
}
variable "key_name" {
    type        = string
    description = "Private key path"
    sensitive   = false
}
variable "region" {
    type        = string
    description = "value for default region"
     default = "us-east-1"
}

variable "enable_dns_hostnames" {
    type        = bool
    description = "Enable DNS hostnames in VPC"
    default     = true
}

variable "map_public_ip_on_launch" {
    type        = bool
    description = "Enable Map ip on launch in Subnet"
    default     = true
}

variable "network_address_space" {
    type        = string
    description = "Base CIDR Block for VPC"
    default = "10.0.0.0/16"
}

variable "cName" {
    type        = string
    description = "Common name for tagging"  
}
  
variable "itclass" {
    type        = string
    description = "Class name for tagging"
}

variable "type" {
    type        = string
    description = "type for tagging"
}

variable "count_subnet" {
  type = number
  description = "count of subnet"
  default = 2
}

variable "count_route" {
  type = number
  description = "count of route"
  default = 2
}

variable "count_instance" {
  type = number
  description = "count of instance"
  default = 2
}

variable "count_lb_attach" {
  type = number
  description = "count of lb attach"
  default = 2
}

variable "count_asg" {
  type = number
  description = "count of autoscaling group"
  default = 2
}

variable "instance_type" {
    type        = string
    description = "type of instance"
    default = "t2.micro"
}

variable "db_type" {
    type        = string
    description = "type of Database"
    default = "db.t3.micro"
}

variable "db_username" {
    type        = string
    description = "Username for Database"
    sensitive   = true
}

variable "db_password" {
    type        = string
    description = "Password for Database"
    sensitive   = true
}

variable "bucket_name_prefix" {
    type        = string
    description = "Prefix for S3 bucket"
    default     = "bucket"
}