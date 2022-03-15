variable "aws_region" {
  type        = string
  default     = ""
  description = "aws region"
}

variable "aws_access_key" {
  type        = string
  default     = ""
  description = "Aws Access Key"
}

variable "aws_secret_access_key" {
  type        = string
  default     = ""
  description = "secret access key"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc_cidr_block"
}

variable "env_prefix" {
  type        = string
  default     = "dev"
  description = "env Prefix"
}

variable "subnet_cidr_block" {
  type        = string
  default     = "10.0.10.0/24"
  description = "subnet_cidr_block"
}

variable "avail_zone" {
  type        = string
  default     = ""
  description = "avail_zone"
}

variable "my_public_ip" {
  type        = string
  description = "my_public_ip"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance_type"
}

variable "public_key_location" {
  type        = string
  default     = ""
  description = "public_key_location"
}
