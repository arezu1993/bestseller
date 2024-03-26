


variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type = string 
  default = "10.0.0.0/16"
}


variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
 
}

variable "subnet_count" {
  description = "Subnet Count"
  default = "2"
}

variable "private_cidr" {
  description = "Private Subnet CIDR Block"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}


variable "public_cidr" {
  description = "Public Subnet CIDR Block"
  type = list(string)
  default = [ "10.0.3.0/24", "10.0.4.0/24" ]
}