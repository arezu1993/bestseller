
resource "aws_security_group" "ec2-sg" {
 name = "ec2-sg"
 description = "Security Group with HTTP  port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
 vpc_id = var.vpc_id
 tags = {
  Name = "ec2-sg"
 }
 ingress {
 description = "HTTP from VPC"
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = [var.vpc_cidr_block]
 }
 egress { 
 from_port = 0
 to_port = 0
 protocol  = -1
 cidr_blocks = ["0.0.0.0/0"]
 }
}
