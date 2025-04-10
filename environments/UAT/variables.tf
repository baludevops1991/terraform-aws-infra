variable "aws_region" {}
#variable "aws_profile" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "azs" {}
variable "environment" {}
variable "public_cidrs" {}
variable "private_cidrs" {}
variable "key_name" {}
variable "db_usernames" {
  description = "List of DB usernames for multiple RDS instances"
  type        = list(string)
}

variable "db_passwords" {
  description = "List of DB passwords for multiple RDS instances"
  type        = list(string)
  sensitive   = true
}
