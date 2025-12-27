# 1. Llave SSH (Global para el entorno)
resource "aws_key_pair" "deployer" {
  key_name   = "SSH-PUB-KEY"
  public_key = file("~/.ssh/id_rsa.pub")
}

# 2. Red Base (VPC, Subnets, IGW)
module "network" {
  source       = "../modules/vpc_base"
  vpc_cidr     = "10.0.0.0/16"
  public_cidr  = "10.0.1.0/24"
  private_cidr = "10.0.2.0/24"
  env          = "dev"
  region       = "us-east-2"
}

# 3. NAT Gateway (Salida a Internet para la red privada)
module "nat" {
  source            = "../modules/nat_gateway"
  vpc_id            = module.network.vpc_id
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  env               = "dev"
}

# 4. Acceso (Bastion Host en Subred Pública)
module "bastion" {
  source           = "../modules/bastion"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  allowed_ip       = "189.149.43.121/32"
  key_name         = aws_key_pair.deployer.key_name
  ami_id           = "ami-00e428798e77d38d9"
  env              = "dev"
}

# 5. Instancia Privada (Servidor de Aplicación)
module "app_instances" {
  source            = "../modules/compute"
  vpc_id            = module.network.vpc_id
  private_subnet_id = module.network.private_subnet_id
  bastion_sg_id     = module.bastion.sg_id
  key_name          = aws_key_pair.deployer.key_name
  ami_id           = "ami-00e428798e77d38d9"
  env               = "dev"
}
