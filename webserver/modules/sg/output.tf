output "security_group_id" {
  value = aws_security_group.ec2-sg.id
}

output "security_group_lb_id" {
  value = aws_security_group.lb_sg.id
  
}
