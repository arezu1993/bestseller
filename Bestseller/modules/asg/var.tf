/*variable "private_subnet_ids" {
  
}*/
variable "target_group_arn" {
  
}

variable "ami_id" {
  type = string
  default = "ami-0c101f26f147fa7fd"

}

variable "instance_type" {
  type = string
  default = "t2.micro"

}

variable "project" {
  default = "bestseller"
}

variable "sg_id" {
  
}
/*
variable "iam_instance_profile_name" {
  
}
*/
variable "max_size" {
  
  default = 3
}
variable "min_size" {
  default = 1
}
variable "desired_capacity" {
    default = 1
  
}
variable "asg_health_check_type" {
  default = "ELB"
}
variable "subnet_ids" {
  
}
#variable "load_balancer_target_group_arn" {
  
#}
#variable "aws_lb" {
  
#}