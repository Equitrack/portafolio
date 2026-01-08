variable "env" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_id" { type = string }
variable "private_route_table_id" { type = string }
variable "ami_id" { type = string }
variable "private_cidr" {
  type = string
  default = "10.0.0.0/16" # Opcional: para restringir el SG
}
variable "key_name" {}
