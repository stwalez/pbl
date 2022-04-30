# Create VPC

module "vpc" {
  source                              = "./modules/VPC"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  enable_classiclink                  = var.enable_classiclink
  enable_classiclink_dns_support      = var.enable_classiclink_dns_support
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
}

module "security" {
  source = "./modules/Security"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "alb" {
  source         = "./modules/ALB"
  vpc_id         = module.vpc.vpc_id
  ext-alb-sg     = module.security.ext-alb-sg
  int-alb-sg     = module.security.int-alb-sg
  public_subnet  = module.vpc.public_subnet
  private_subnet = module.vpc.private_subnet

  tags = var.tags
}

module "autoscaling" {
  source           = "./modules/Autoscaling"
  available_azs    = module.vpc.available_azs
  region           = var.region
  images           = var.images
  bastion_sg       = module.security.bastion_sg
  webserver_sg     = module.security.webserver_sg
  nginx_sg         = module.security.nginx_sg
  instance_profile = module.iam.instance_profile
  tags             = var.tags
  keypair          = var.keypair
  private_subnet   = module.vpc.private_subnet
  public_subnet    = module.vpc.public_subnet
  nginx_tg         = module.alb.alb_nginx_tg_arn
  wordpress_tg     = module.alb.alb_wordpress_tg_arn
  tooling_tg       = module.alb.alb_tooling_tg_arn
}

module "iam" {
  source = "./modules/IAM"
  tags   = var.tags

}

module "efs" {
  source         = "./modules/EFS"
  account_no     = var.account_no
  tags           = var.tags
  private_subnet = module.vpc.private_subnet
  datalayer_sg   = module.security.datalayer_sg
}

module "rds" {
  source          = "./modules/RDS"
  master-username = var.master-username
  master-password = var.master-password
  private_subnet  = module.vpc.private_subnet
  tags            = var.tags
  datalayer_sg    = module.security.datalayer_sg
}


