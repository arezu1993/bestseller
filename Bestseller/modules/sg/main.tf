# security group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  /*
  # Allow SSH access from the VPN range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpn_cidr_blocks
  }
  */

 # Allow outbound traffic to NAT Gateway
  egress {
    from_port   = 0  
    to_port     = 65535  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Allow incoming traffic from the load balancer
  ingress {
    from_port   = 0  
    to_port     = 0  
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    # Allow inbound traffic from ELB
  ingress {
    from_port   = 0  
    to_port     = 65535 
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]  
  }
  
  tags = local.common_tags
  # You can add other ingress and egress rules as needed
}

# security group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Security group for Load Balancer"
  vpc_id = var.vpc_id
 
#Allow incoming request frome port 80 and 443 (http and https)

   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow outbound traffic to the EC2 instances
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to any destination
  }
/*
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  */
 
 #Allow all outgoing requests
 egress {
 from_port = 0
 to_port = 0
 protocol  = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }

 tags = local.common_tags 

 egress {
    from_port   = 0  
    to_port     = 65535  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
   ingress {
    from_port   = 0  
    to_port     = 65535  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
   ingress {
    from_port   = 0  
    to_port     = 65535  
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
    
   }  
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
