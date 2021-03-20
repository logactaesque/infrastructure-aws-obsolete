resource "aws_acm_certificate" "logactaesque-domain-certificate" {
  domain_name       = "*.${var.logactaesque-domain-name}"
  validation_method = "DNS"

  tags = {
    Name = "Logactaesque Domain Certificate"
  }
}

data "aws_route53_zone" "logactaesque_domain_zone" {
  name         = var.logactaesque-domain-name
  private_zone = false
}

resource "aws_route53_record" "logactaesque_domain_cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.logactaesque-domain-certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 60
  zone_id         = data.aws_route53_zone.logactaesque_domain_zone.zone_id

}

resource "aws_acm_certificate_validation" "logactaesque_domain_cert_validation" {
  certificate_arn         = aws_acm_certificate.logactaesque-domain-certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.logactaesque_domain_cert_validation_record : record.fqdn]
}