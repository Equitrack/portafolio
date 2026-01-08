resource "aws_security_group" "private_sg" {
  name   = "${var.env}-private-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id] # Solo permite entrada desde el Bastion
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags                   = { Name = "${var.env}-jenkins" }
  user_data = <<-EOF
              #!/bin/bash
              dnf install -y docker
              systemctl enable --now docker
              sudo usermod -aG docker ec2-user
              EOF
}

resource "aws_instance" "minikube" {
  ami                    = var.ami_id
  instance_type          = "c7i-flex.large"
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  tags                   = { Name = "${var.env}-minikube" }
  user_data = <<-EOF
              #!/bin/bash
              dnf install -y docker
              systemctl enable --now docker
              sudo usermod -aG docker ec2-user
              EOF
}

# EBS - Jenkins data
resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = aws_instance.jenkins.availability_zone
  size              = 10
  type              = "gp3"
  tags = { Name = "${var.env}-jenkins-data" }
}

# Attatch ebs to jenkins
resource "aws_volume_attachment" "jenkins_data_att" {
  device_name = "/dev/sdh" # AWS lo mapeará como /dev/xvdh o /dev/nvme1n1
  volume_id   = aws_ebs_volume.jenkins_data.id
  instance_id = aws_instance.jenkins.id
}
