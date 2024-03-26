output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}


output "private_subnet_ids" {
  description = "The ID of the Private_Subnet"
  value = aws_subnet.private_subnets[*].id

}

output "elb_subnet_id" {
  value = aws_subnet.elb_subnets[*].id
}
output "nat_subnet_id" {
  value = aws_subnet.nat_subnet.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}


output "eip_allocation_id" {
  value = aws_eip.nat.id
}


output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "availability_zones" {
  value = var.vpc_availability_zones
  
}

output "private_acl_id" {
  value       = aws_network_acl.private_acl.id
}

output "nat_acl_id" {
  value       = aws_network_acl.nat_acl.id
}
/*
output "elb_acl_id" {
  value       = aws_network_acl.elb_acl.id
}
*/
output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}
