
output "target_group_arn" {
  value = aws_lb_target_group.Target_group.arn
}

output "load_balancer_arn" {
  value = aws_lb.alb.arn
}