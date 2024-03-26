
# Terraform AWS Application Load Balancer (ALB)
resource "aws_lb" "alb" {

  name = "alb"
  load_balancer_type = "application"
  subnets = var.elb_subnets
  security_groups = [var.alb_sg_id]
  internal           = false
  tags = local.common_tags

}

 #Target Group
resource "aws_lb_target_group" "Target_group" {
      name                              = "Target-group"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      load_balancing_cross_zone_enabled = true
      protocol_version = "HTTP1"
      vpc_id = var.vpc_id

      health_check  {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      tags = local.common_tags
}
/*
# LB Target Group Attachment
resource "aws_lb_target_group_attachment" "tg" {
  for_each = {for k,v in var.instance_ids: k => v}
  target_group_arn = aws_lb_target_group.Ec2_Target_group.arn
  target_id        = each.value
  port             = 80
}
*/

resource "aws_autoscaling_attachment" "bestseller" {
  autoscaling_group_name = var.autoscaling_group_name
  lb_target_group_arn   = aws_lb_target_group.Target_group.arn
  
}

# Listener
resource "aws_lb_listener" "listener" {
  depends_on = [ aws_lb_target_group.Target_group]
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Target_group.arn
  }
}







