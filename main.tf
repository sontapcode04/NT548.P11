provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}


# create vpc
module "vpc" {
  source = "./module/vpc"
  project_name = var.project_name
  vpc_cidr = var.vpc_cidr
  public_subnet_az1_cidrs = var.public_subnet_az1_cidrs
  private_subnet_az1_cidrs=var.private_subnet_az1_cidrs
  region = var.region
}

# create nat

module "nat-gateway" {
  source = "./module/nat-gateway"
  vpc_id = module.vpc.vpc_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  private_subnet_az1_id =module.vpc.private_subnet_az1_id
  internet_gateway =module.vpc.internet_gateway

}

module "security-group" {
  source = "./module/security-group"
  vpc_id = module.vpc.vpc_id
  project_name = module.vpc.project_name
  my_ip_address = var.my_ip_address
}

module "EC2_public" {
  source = "./module/EC2"
  ami_id = var.ami_id
  project_name = module.vpc.project_name
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_az1_id
  key_name = var.key_name
  security_group_ids = [module.security-group.public_ec2_sg]
  instance_name = "public_EC2"
}

module "EC2_Private"{
  source = "./module/EC2"
  ami_id = var.ami_id
  project_name = module.vpc.project_name
  instance_type = var.instance_type
  subnet_id = module.vpc.private_subnet_az1_id
  key_name = var.key_name
  security_group_ids = [module.security-group.private_ec2_sg]
  instance_name = "private_EC2"
}