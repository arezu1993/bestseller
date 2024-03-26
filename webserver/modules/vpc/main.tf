
resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true



   tags = local.common_tags

}

resource "aws_subnet" "private_subnets" {
  count = var.subnet_count
  vpc_id                  =  aws_vpc.vpc.id         
  availability_zone       =  element(var.vpc_availability_zones, count.index)
  map_public_ip_on_launch = false  # No public IP for instances in private subnets
  cidr_block              = element(var.private_cidr, count.index)

  tags = local.common_tags

}


resource "aws_subnet" "public_subnets" {
    count = var.subnet_count

  vpc_id                  =  aws_vpc.vpc.id         
  availability_zone       =  element(var.vpc_availability_zones, count.index)
  map_public_ip_on_launch = true 
  cidr_block              = element(var.public_cidr, count.index)

   tags = local.common_tags

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = local.common_tags
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  

  route {
    
      gateway_id = aws_internet_gateway.gw.id
      cidr_block = "0.0.0.0/0"
    
  }

}

resource "aws_route_table_association" "rt_public_association" {
    for_each = {for k,v in aws_subnet.public_subnets: k => v}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "rt_private_association" {
    for_each = {for k,v in aws_subnet.private_subnets: k => v}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.vpc.id

  egress {
    protocol   = "all"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "allow ec2 internet access"
  }
}