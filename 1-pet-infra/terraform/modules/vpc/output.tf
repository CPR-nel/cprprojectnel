output "vpc_id"{
    value = aws_vpc.main_vpc.id
}   

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}



# output "public_subnet1"{
#     value = aws_subnet.Public-Subnet-1.id
# }

# output "private_subnet1"{
#     value = aws_subnet.Private-Subnet-1.id
# }

# output "web_ip" {
#     value = aws_eip.web-eip1.address
# }