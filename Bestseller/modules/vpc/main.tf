#Create AWS vpc
resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

   tags = local.common_tags

}

#Create private subnet for EC2
resource "aws_subnet" "private_subnets" {
  count = var.private_subnet_count
  vpc_id                  =  aws_vpc.vpc.id         
  availability_zone       =  element(var.vpc_availability_zones, count.index)
  map_public_ip_on_launch = false  # No public IP for instances in private subnets
  cidr_block              = element(var.private_cidr, count.index)

  tags = local.common_tags

}


# Create public subnets for load balancer in two out of three Availability Zones
resource "aws_subnet" "elb_subnets" {
  count                   = var.lb_count
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.vpc_availability_zones, count.index)
  cidr_block              = element(var.elb_cidr, count.index)
  map_public_ip_on_launch = true
  tags = local.common_tags
}


#Create public subnet for NAT Gateway
resource "aws_subnet" "nat_subnet" {

  vpc_id                  =  aws_vpc.vpc.id         
  availability_zone       =  element(var.vpc_availability_zones, 2) 
  map_public_ip_on_launch = false # eip will be assigned to the gateway net
  cidr_block              = var.nat_cidr

   tags = local.common_tags

}

#Create internet gateway for internet acceess
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
 
  tags = local.common_tags
}

#Create route table for internet acceess and add route to internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  

  route {
    
      gateway_id = aws_internet_gateway.gw.id
      cidr_block = "0.0.0.0/0"
    
  }

   tags = local.common_tags

}


# Associate Route Table with ELB Subnet
resource "aws_route_table_association" "elb_subnet_association" {
  for_each = { for idx, subnet in aws_subnet.elb_subnets : idx => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Associate Route Table with Nat Subnet
resource "aws_route_table_association" "nat_subnet_association" {
  

  subnet_id      = aws_subnet.nat_subnet.id
  route_table_id = aws_route_table.public.id
}


# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat" {

   tags = local.common_tags
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id  
  subnet_id     = aws_subnet.nat_subnet.id  

   tags = local.common_tags
}

# Create Route Table for Private Subnet and add Route to NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block        = "0.0.0.0/0"
    nat_gateway_id    = aws_nat_gateway.nat.id  
  }

   tags = local.common_tags

}

# Associate Route Table with Private Subnets
resource "aws_route_table_association" "private_association" {
   for_each = { for idx, subnet_id in aws_subnet.private_subnets : idx => subnet_id }
  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Create Network ACL for Private Subnet
resource "aws_network_acl" "private_acl" {
  vpc_id = aws_vpc.vpc.id

  # Outbound rule allowing all traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  /*
  # Inbound rule allowing SSH traffic from VPN IP range
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "vpn_ip_range"  
    from_port  = 22
    to_port    = 22
  }

  
*/
   # Inbound rule allowing HTTP access from ELB
  ingress {
    protocol        = "tcp"
    rule_no         = 200
    action          = "allow"
    cidr_block      = var.vpc_cidr
    from_port       = 80
    to_port         = 80
  }

   tags = local.common_tags
}

# Associate Network ACL with Private Subnets
resource "aws_network_acl_association" "private_acl_association" {
  for_each = { for idx, subnet_id in aws_subnet.private_subnets : idx => subnet_id }

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.private_acl.id
}

# Create Network ACL for NAT Subnet
resource "aws_network_acl" "nat_acl" {
  vpc_id = aws_vpc.vpc.id

  # Outbound rule allowing all traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Inbound rule allowing only established connections
  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    icmp_type  = 3
    icmp_code  = 4
  }

 tags = local.common_tags
   
}

# Associate Network ACL with NAT Subnet
resource "aws_network_acl_association" "nat_acl_association" {
  subnet_id      = aws_subnet.nat_subnet.id  
  network_acl_id = aws_network_acl.nat_acl.id
}

/*

# Create Network ACL for ELB Subnet
resource "aws_network_acl" "elb_acl" {
  vpc_id = aws_vpc.vpc.id

  # Inbound rule allowing HTTP traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"  
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"  
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 700
    action     = "allow"
    cidr_block = "0.0.0.0/0"  
    from_port  = 443
    to_port    = 443
  }


 
  # Outbound rule allowing all traffic
  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"  
    from_port  = 0
    to_port    = 0
  }
 

   egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"  
    from_port  = 80
    to_port    = 80
  }

   egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"  
    from_port  = 443
    to_port    = 443
  }
   
   egress {
    protocol   = "tcp"
    rule_no    = 800
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024  
    to_port    = 65535 
  }
  tags = local.common_tags

}

# Associate Network ACL with ELB Subnet
resource "aws_network_acl_association" "elb_acl_association" {
  for_each = { for idx, subnet in aws_subnet.elb_subnets : idx => subnet }

  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.elb_acl.id
}

*/