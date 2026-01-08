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
  vpc_security_group_ids = [aws_security_group.private_sg.id, 
                            aws_security_group.k8s_comm_sg.id]
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
  vpc_security_group_ids = [aws_security_group.private_sg.id, 
                            aws_security_group.k8s_comm_sg.id]
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

# SECURITY GROUP TO MINIKUBE AND JENKINS
resource "aws_security_group" "k8s_comm_sg" {
  name        = "${var.env}-k8s-comm-sg"
  description = "Comunicacion especifica entre Jenkins y Minikube"
  vpc_id      = var.vpc_id

  # Puerto API Kubernetes
  ingress {
    from_port       = 8443
    to_port         = 8443
    protocol        = "tcp"
    self            = true # Permite que miembros del mismo SG se hablen
  }

  # Puerto Agentes Jenkins (JNLP)
  ingress {
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    self            = true
  }

  # Puerto UI/WebSocket (Necesario para que el agente responda a Jenkins)
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.env}-k8s-comm-sg" }
}
