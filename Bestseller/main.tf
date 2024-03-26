module "vpc" {
  source = "./modules/vpc"
 

}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"

}

module "loadbalancer" {

  source       = "./modules/loadbalancer"
  vpc_id       = module.vpc.vpc_id
  elb_subnets  = module.vpc.elb_subnet_id
  alb_sg_id    = module.sg.lb_sg_id
  autoscaling_group_name = module.asg.autoscaling_group_name
 # instance_ids = module.ec2.instance_ids

}
/*
module "ec2" {
  depends_on   = [module.vpc]
  source       = "./modules/ec2"
  sg_id        = module.sg.ec2_sg_id
  subnet_ids   = module.vpc.private_subnet_ids
  iam_instance_profile_name = module.iam.iam_instance_profile_name

}
*/
module "asg" {

source       = "./modules/asg"
depends_on   = [module.vpc]
#iam_instance_profile_name = module.iam.iam_instance_profile_name
#private_subnet_ids = module.vpc.private_subnet_ids
target_group_arn  = module.loadbalancer.target_group_arn
sg_id = module.sg.lb_sg_id
subnet_ids = module.vpc.elb_subnet_id
#load_balancer_target_group_arn = module.loadbalancer.target_group_arn
#aws_lb = module.loadbalancer
}

