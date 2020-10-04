data "aws_availability_zones" "available" {}
variable "vpc_cidr" {}

variable "cidrs" {
  type = map
}
variable "localip" {}
variable "key_name" {}
variable "public_key_path" {}
variable "web_instance_type" {}
variable "bastion_instance_type" {}
variable "db_instance_type" {}
variable "db_username" {}
variable "db_password" {}
variable "dev_ami" {}
variable "userdatascript" {}
