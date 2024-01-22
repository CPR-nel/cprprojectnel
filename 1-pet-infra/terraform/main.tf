terraform {
  backend "s3" {
    bucket         = "nel-backend-tfstate"
    key            = "pet/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    }
}

# Security Groups
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source                     = "./modules/vpc"
  web_vpc_cidr               = var.cidr_block
  web_vpc_tenancy            = var.web_vpc_tenancy
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "key-pair" {
  source   = "./modules/key-pair"
  key_name = var.key_name
  home_dir = var.home_dir # used for storing pem file
}

# Elastic Cloud Compute
module "ec2" {
  source               = "./modules/ec2"
  ami                  = var.ami
  type                 = var.type
  az                   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  key_pair             = module.key-pair.key_name
  web_security_groups_id = module.sg.web_security_groups_id
  env                  = var.env
  public_subnet_ids    = module.vpc.public_subnet_ids
}

# rds
module "rds" {
  source               = "./modules/rds"
  identifier           = var.identifier
  instance_class       = var.instance_class
  allocated_storage    = var.db_storage
  engine               = var.engine
  engine_version       = var.engine_version
  username             = var.username
  password             = var.db_password
  private_subnets      = module.vpc.private_subnet_ids
  db_security_group_id = module.sg.database_security_groups_id
}

# Generate ansible_vars.json using null_resource and local-exec
resource "null_resource" "generate_ansible_vars" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF
      echo '{
        "web_server_ip": "${module.ec2.web_server_1_public_ip}",
        "rds_hostname": "${module.rds.rds_hostname}"
      }' > ansible_vars.json
    EOF
  }
}
