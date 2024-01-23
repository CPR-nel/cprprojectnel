# AWS Configuration
aws_profile = "default"
region      = "us-east-2"

# Virtual Private Cloud (VPC) Configuration
availability_zones         = ["us-east-2a", "us-east-2b"]
cidr_block                 = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidr_blocks  = ["10.0.1.0/24"]

# Elastic Cloud Compute (EC2) Configuration
ami  = "ami-024e6efaf93d85776" # Ubuntu image
env  = "Dev"
type = "t3.medium"

# Key Pair Configuration
home_dir = "/var/lib/jenkins"
key_name = "docupet"

# Amazon RDS Configuration
db_password    = "Password0123"
db_storage     = 20
engine         = "mysql"
engine_version = "5.7"
identifier     = "docupet"
instance_class = "db.t3.medium"
storage_type   = "gp2"
username       = "admin"
