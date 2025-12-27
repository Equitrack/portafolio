output "acceso_bastion_ip" {
  value = module.bastion.public_ip
}

output "servidor_privado_ip" {
  # Cambiamos: aws_instance.app_server.private_ip
  # Por:
  value = module.app_instances.private_ip
}
