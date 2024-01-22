output "key_name"{
  value = aws_key_pair.deployer.key_name
}

output "pem_key_file_path" {
  value = local_file.web-test.filename
}