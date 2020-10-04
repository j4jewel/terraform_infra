#--ALB-Security--group

resource "aws_security_group" "alb_sg" {
  name        = "ALB_security_group"
  description = "ALB-SG"
  vpc_id      = aws_vpc.wp_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "my-alb" {

  name            = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = [aws_subnet.wp_public1_subnet.id, aws_subnet.wp_public2_subnet.id]

}

resource "aws_lb_target_group" "group" {
  name     = "Alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.wp_vpc.id
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "alb" {
  target_group_arn = aws_lb_target_group.group.arn
  target_id        = aws_instance.webinstance.id
  port             = 80
}