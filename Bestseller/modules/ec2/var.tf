
variable "instance_type" {
  type = string
  default = "t2.micro"

}

# Instance Count
variable "instance_count" {
  type        = number
  default     = 1
}


variable "subnet_ids" {
  
}

variable "sg_id" {
  
}

variable "iam_instance_profile_name" {
  
}
variable "iam_id" {
  type = string
  default = "ami-0c101f26f147fa7fd"

}

