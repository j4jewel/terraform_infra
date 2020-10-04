 
 #---Security groups----

 resource "aws_security_group" "web-sg" {

  name = "webserver-sg"
  vpc_id      = aws_vpc.wp_vpc.id
  tags = {
      Name = "Webserver-SG"
  }

  ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     security_groups = [aws_security_group.bastion-sg.id]
  }

  ingress {
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

 resource "aws_security_group" "bastion-sg" {

  name = "bastion-sg"
  vpc_id      = aws_vpc.wp_vpc.id
  tags = {
      Name = "Bastion-SG"
  }

  ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = [var.localip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


#---Key-Pair----

resource "aws_key_pair" "wp_auth" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
}
 
 
 #---EC2-INSTANCE----

resource "aws_instance" "webinstance" {

  ami = var.dev_ami
  instance_type = var.web_instance_type
  key_name = aws_key_pair.wp_auth.id
  subnet_id = aws_subnet.wp_public1_subnet.id
  user_data = file(var.userdatascript)
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]
  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "bastion" {

  ami = var.dev_ami
  instance_type = var.bastion_instance_type
  key_name = aws_key_pair.wp_auth.id
  subnet_id = aws_subnet.wp_public1_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  tags = {
    Name = "Bastion"
  }
}

