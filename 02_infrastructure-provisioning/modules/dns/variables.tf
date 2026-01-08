variable "vpc_id" {
  description = "ID de la VPC donde se asociará la zona privada de Route 53"
  type        = string
}

variable "domain_name" {
  description = "Nombre del dominio para la zona hospedada privada (ej: dev.internal)"
  type        = string
  default     = "dev.internal"
}

variable "instance_map" {
  description = "Mapa de nombres de host e IPs privadas (ej: { 'app-01' = '10.0.1.5' })"
  type        = map(string)
}
