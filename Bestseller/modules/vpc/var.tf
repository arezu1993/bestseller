variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type = string 
  default = "10.0.0.0/16"
}


variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" , "us-east-1c" ]
 
}

variable "private_subnet_count" {
  description = "Subnet Count"
  default = "3"
}
variable "private_cidr" {
  description = "Private Subnet CIDR Block"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" , "10.0.3.0/24"]
}


variable "elb_cidr" {
  description = " ELB Subnet CIDR Block"
  type = list(string)
  default =  [ "10.0.4.0/24" , "10.0.5.0/24" ] 
}

variable "nat_cidr" {
  description = "Public Subnet CIDR Block"
  type = string
  default =  "10.0.6.0/24"
}

variable "lb_count" {
  default =  "2"
}

