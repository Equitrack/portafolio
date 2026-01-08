output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_route_table_id" {
  value       = aws_route_table.public_rt.id 
}

output "private_route_table_id" {
  description = "ID de la tabla de rutas privada para asociar la NAT Instance"
  value       = aws_route_table.private_rt.id
}


