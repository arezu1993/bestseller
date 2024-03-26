/*
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-key" 
  public_key = file("${path.module}/id_rsa.pub")  
}
*/
resource "aws_launch_template" "bestseller" {
  name          = "${var.project}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type 
  key_name  = "test" 
  user_data = filebase64("${path.module}/script.sh")
  vpc_security_group_ids = [var.sg_id]
}

resource "aws_autoscaling_group" "bestseller" {

  name                      = "${var.project}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type #"ELB" or default EC2
  vpc_zone_identifier = var.subnet_ids
  #target_group_arns   = [var.load_balancer_target_group_arn] #var.target_group_arns

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.bestseller.id
    version = aws_launch_template.bestseller.latest_version #"$Latest"
  }
 
}

# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.bestseller.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80" # New instance will be created once CPU utilization is higher than 80 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.bestseller.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.bestseller.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60" # Instance will scale down when CPU utilization is lower than 60 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.bestseller.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}