# Web Server 1
resource "aws_instance" "web_server_1" {
  ami               = var.ami
  instance_type     = var.type
  availability_zone = var.az[0]
  key_name          = var.key_pair
  associate_public_ip_address = true
  subnet_id = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.web_security_groups_id]
  tags = {
    Name = "web_server"
    Environment = var.env
  }
}





  