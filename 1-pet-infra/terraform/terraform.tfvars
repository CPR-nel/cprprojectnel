# AWS
aws_profile = "default"
region      = "us-east-2"

# vpc
cidr_block                 = "10.0.0.0/16"
availability_zones         = ["us-east-2a", "us-east-2b"]
public_subnet_cidr_blocks  = ["10.0.1.0/24"]
private_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]


# EC2
env  = "Dev"
ami  = "ami-024e6efaf93d85776" # ubuntu image
type = "t3.medium"

# RDS
identifier     = "docupet"
instance_class = "db.t3.medium"
storage_type   = "gp2"
db_storage     = 20
engine         = "mysql"
engine_version = "5.7"
username       = "admin"
db_password    = "Password0123"

# key-pair
home_dir = "/var/lib/jenkins"
key_name = "docupet"