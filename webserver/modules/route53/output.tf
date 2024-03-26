
output "domain_zoneid" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  value = data.aws_route53_zone.certificate_route53_zone.zone_id 
}


output "domain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value = data.aws_route53_zone.certificate_route53_zone.name
}

output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}
