output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.db_instance.address
}

output "rds_endpoint"{
  description = " Name of the RDS endpoint"
  value = aws_db_instance.db_instance.endpoint
}