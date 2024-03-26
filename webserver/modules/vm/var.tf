# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instnace Type"
  type = string
  default = "t2.micro"

}

# Instance Count
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}


variable "subnet_ids" {
  
}
variable "sg_id" {
  
}

