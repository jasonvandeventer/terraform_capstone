# Request a public certificate via ACM (manual DNS validation)
resource "aws_acm_certificate" "main" {
  count             = var.low_cost ? 0 : 1
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "capstone-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Finalizes validation once DNS CNAME record is manually added (Cloudflare, etc.)
resource "aws_acm_certificate_validation" "main" {
  count           = var.low_cost ? 0 : 1
  certificate_arn = aws_acm_certificate.main[0].arn

  validation_record_fqdns = [
    for dvo in aws_acm_certificate.main[0].domain_validation_options :
    dvo.resource_record_name
  ]
}

