variable "web_sg_name" {
    type = string
    default = "allow_web_traffic"
    description = "Name of Web Security Group"

}
variable "db_sg_name" {
    type = string
    default = "DB-sg"
    description = "Name of Database Security Group"
}

variable "vpc_id" {

}