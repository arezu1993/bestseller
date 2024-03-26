
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}


output "private_subnet_ids" {
  description = "The ID of the Private_Subnet"
  value = aws_subnet.private_subnets[*].id

}



output "public_subnet_ids" {
   description = "The ID of the Public_Subnet"
  value = aws_subnet.public_subnets[*].id

}


output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "availability_zones" {
  value = var.vpc_availability_zones
  
}