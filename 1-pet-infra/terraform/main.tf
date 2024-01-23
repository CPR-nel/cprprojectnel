terraform {
  backend "s3" {
    bucket         = "nel-backend-tfstate"
    key            = "pet/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
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

# Module for Key Pair
module "key-pair" {
  home_dir = var.home_dir # used for storing pem file
  key_name = var.key_name
  source   = "./modules/key-pair"
}

# Module for Virtual Private Cloud (VPC)
module "vpc" {
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  source                     = "./modules/vpc"
  web_vpc_cidr               = var.cidr_block
  web_vpc_tenancy            = var.web_vpc_tenancy
}

# Module for Security Groups
module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

# Module for Elastic Cloud Compute (EC2)
module "ec2" {
  ami                  = var.ami
  az                   = var.availability_zones
  env                  = var.env
  key_pair             = module.key-pair.key_name
  public_subnet_ids    = module.vpc.public_subnet_ids
  source               = "./modules/ec2"
  type                 = var.type
  vpc_id               = module.vpc.vpc_id
  web_security_groups_id = module.sg.web_security_groups_id
}

# Module for Amazon RDS
module "rds" {
  allocated_storage    = var.db_storage
  db_security_group_id = module.sg.database_security_groups_id
  engine               = var.engine
  engine_version       = var.engine_version
  identifier           = var.identifier
  instance_class       = var.instance_class
  password             = var.db_password
  private_subnets      = module.vpc.private_subnet_ids
  source               = "./modules/rds"
  username             = var.username
}
