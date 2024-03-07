provider "aws" {
  region = var.region
}



#Security Group Load Balancer

data "aws_vpc" "vpc_id" {
  id = "vpc-0cf3b31ebba781f07"
}

data "aws_subnet" "subnet1" {
  id = "subnet-02ec4e9fce4b856e1"
}

data "aws_subnet" "subnet2" {
  id = "subnet-052bc856af02547eb"
}

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "LoadBalancerSG"
  vpc_id      = data.aws_vpc.vpc_id.id

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

#Load Balancer

resource "aws_lb" "alb" {
  name            = "DeveqiALB"
  security_groups = [aws_security_group.alb.id]
  subnets         = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]

}


resource "aws_lb_target_group" "lbtg" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_id.id

  health_check {
    path              = "/"
    healthy_threshold = 5
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lbtg.arn
  }
}


resource "aws_security_group" "autoscaling" {
  name        = "autoscaling"
  description = "Security group auto scaling"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}


#EC2 AUTO SCALING


resource "aws_launch_template" "launchtp" {
  name_prefix = "deveqi"
  image_id = var.ami_id
  instance_type = var.instance-type
  key_name = aws_key_pair.key.key_name
  user_data = filebase64("ec2-setup.sh")



  monitoring {
    enabled = true
  }

  network_interfaces {
     associate_public_ip_address = true
     delete_on_termination = true
     security_groups = [aws_security_group.autoscaling.id]
  }
}

resource "aws_instance" "vm" {
  ami                         = var.ami_id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = data.aws_subnet.subnet1.id
  vpc_security_group_ids      = [aws_security_group.autoscaling.id, aws_security_group.alb.id]
  associate_public_ip_address = true

  tags = {

    name = "deveqi-vm"
  }


}