#---RDS-Security group----

 resource "aws_security_group" "rds-sg" {

  name = "RDS-sg"
  vpc_id      = aws_vpc.wp_vpc.id
  tags = {
      Name = "RDS-SG"
  }

  ingress {
     from_port = 3306
     to_port = 3306
     protocol = "tcp"
     security_groups = [aws_security_group.web-sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_db_subnet_group" "db-subnet" {

name = "db-subnet-group"
subnet_ids = [aws_subnet.wp_private1_subnet.id, aws_subnet.wp_private2_subnet.id]

}

resource "aws_db_instance" "default" {

allocated_storage = 20
identifier = "rds-wp"
storage_type = "gp2"
engine = "mysql"
engine_version = "5.7"
instance_class = var.db_instance_type
name = "testmysql"
username = var.db_username
password = var.db_password
parameter_group_name = "default.mysql5.7"
db_subnet_group_name = aws_db_subnet_group.db-subnet.name
vpc_security_group_ids = [aws_security_group.rds-sg.id]

}