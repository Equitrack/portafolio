# 1. Creamos la NAT Instance en la Subred PÚBLICA
resource "aws_instance" "nat_instance" {
  tags                        = { Name = "${var.env}-nat-instance" }
  ami                         = var.ami_id  # Amazon Linux 2023 (Verifica en tu región)
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  associate_public_ip_address = true

  # CRÍTICO: Permite que la instancia procese tráfico que no es suyo
  source_dest_check = false

  user_data = <<-EOF
              #!/bin/bash
              # ENABLE KERNEL FORWARDING
              echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
              sysctl -p
              # INSTALL AND ENABLE TOOLS
              dnf install -y iptables-services
              systemctl enable --now iptables
              # ENABLE NAT
              IFACE=$(ip route | grep default | awk '{print $5}')
              iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE
              # CHANGE RULES
              iptables -P INPUT ACCEPT
              iptables -P FORWARD ACCEPT
              iptables -P OUTPUT ACCEPT
              # SAVE CHANGE POST RESTART
              service iptables save
              EOF
}

# 2. El Security Group debe permitir tráfico de la Subred PRIVADA
resource "aws_security_group" "nat_sg" {
  name        = "${var.env}-nat-instance-sg"
  description = "Permitir trafico de salida de la red privada"
  vpc_id      = var.vpc_id

  # Permitir entrada desde el CIDR de tu subred privada
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.private_cidr]

  }

  # Permitir salida total a Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. ACTUALIZAR la Tabla de Rutas de la Subred Privada
resource "aws_route" "private_nat_route" {
  route_table_id         = var.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"

  # Apuntamos a la interfaz de red primaria de la instancia NAT
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}
