resource "aws_route53_zone" "private" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "instances" {
  for_each = var.instance_map
  zone_id  = aws_route53_zone.private.zone_id
  name     = "${each.key}.${var.domain_name}"
  type     = "A"
  ttl      = 300
  records  = [each.value]
}
