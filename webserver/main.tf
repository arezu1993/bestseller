


module "vpc" {
    source = "./modules/vpc"
   
   
}
module "dns" {
  source = "./modules/route53"
  dns_name  = module.alb.dns_name
  zone_id = module.alb.zone_id
  subdomain = var.subdomain
  
}


module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

} 

module "ec2" {
  depends_on = [ module.vpc ]
    source = "./modules/vm"
    sg_id = module.sg.security_group_id
    subnet_ids = module.vpc.private_subnet_ids
    

  
}

module "alb" {

  source = "./modules/alb"
  vpc_id =  module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id = module.sg.security_group_lb_id
  instance_ids = module.ec2.instance_ids
  certificate_arn = module.dns.certificate_arn
}



