output "web_security_groups_id" {
    value = aws_security_group.allow_web.id
}

output "web_security_groups_id_name" {
  value = aws_security_group.allow_web.name
}


output "database_security_groups_id" {
    value = aws_security_group.database_sg.id
}
