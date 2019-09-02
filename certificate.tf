resource "aws_acm_certificate" "web_site_certificate" {
  domain_name       = "${var.project_name}"
  validation_method = "DNS"

  provider = "aws.certificateEligibleRegion"

  subject_alternative_names = ["${var.project_name}", "www.${var.project_name}"]
}

resource "aws_route53_record" "cert_validation" {
  name     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_type}"
  zone_id  = "${aws_route53_zone.web_site_zone.zone_id}"
  records  = ["${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_value}"]
  ttl      = 300
}
resource "aws_route53_record" "www_cert_validation" {
  name     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.1.resource_record_name}"
  type     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.1.resource_record_type}"
  zone_id  = "${aws_route53_zone.web_site_zone.zone_id}"
  records  = ["${aws_acm_certificate.web_site_certificate.domain_validation_options.1.resource_record_value}"]
  ttl      = 300
}


resource "aws_acm_certificate_validation" "web_site_certificate_validation" {
  provider = "aws.certificateEligibleRegion"

  certificate_arn         = "${aws_acm_certificate.web_site_certificate.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}", "${aws_route53_record.www_cert_validation.fqdn}"]
}