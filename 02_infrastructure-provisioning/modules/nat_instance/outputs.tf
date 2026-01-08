output "nat_instance_id" {
  value = aws_instance.nat_instance.id
}

output "nat_private_ip" {
  value = aws_instance.nat_instance.private_ip
}
