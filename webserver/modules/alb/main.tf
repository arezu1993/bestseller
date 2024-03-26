
resource "aws_lb" "alb" {

  name = "alb"
  load_balancer_type = "application"
  
  subnets = var.public_subnets
  security_groups = [var.alb_sg_id]
  internal           = false
  enable_deletion_protection = false
  
  tags = local.common_tags

}

resource "aws_lb_target_group" "tg" {
      name                              = "tg"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
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

resource "aws_lb_target_group_attachment" "tg" {
  for_each = {for k,v in var.instance_ids: k => v}
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 80
}



resource "aws_lb_listener" "http_listener"{
  depends_on = [ aws_lb_target_group.tg ]
  port     = "80"
  load_balancer_arn = aws_lb.alb.arn
  protocol = "HTTP"
  default_action {
  type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }   
}

resource "aws_lb_listener" "listener" {
  depends_on = [ aws_lb_target_group.tg ]
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
   ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn             = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}








