variable "access_key"  {
  default  = "AKIASBAOK34Y6GAP725H"
}
variable "secret_key" {
  default  = "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"
}
variable "project_name" {
  default = "shared_vpc"
}
variable "env" {
  default = "test"
}
variable "region" {
  default = "us-east-2"
}
variable "cidr_vpc" {
  default = "10.40.0.0/22"
}
variable "public_subnet_2a" {
  default = "10.40.2.0/24"
}
variable "public_subnet_2b" {
  default = "10.40.3.0/24"
}
variable "private_subnet_2a" {
  default = "10.40.0.0/24"
}
variable "private_subnet_2b" {
  default = "10.40.1.0/24"
}
