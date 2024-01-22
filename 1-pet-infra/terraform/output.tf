output "web_server_ip" {
  value = module.ec2.web_server_1_public_ip
}

output "rds_hostname" {
  value = module.rds.rds_hostname
}