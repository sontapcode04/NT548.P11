resource "aws_security_group" "public_ec2_sg" {
    vpc_id = var.vpc_id

  egress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

    ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.my_ip_address]
    
  }
  tags = {
    Name = "${var.project_name}public-ec2-sg"
  }
  
}

resource "aws_security_group" "private_ec2_sg" {
    vpc_id = var.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups = [aws_security_group.public_ec2_sg.id]
    
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  tags = {
    Name = "${var.project_name}private-ec2-sg"
  }
  
}