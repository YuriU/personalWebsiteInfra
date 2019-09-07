# Default instance of provider
provider "aws" {
}

# Region where certificates must be created. 
# CloudFront see with certificates created in N.Virginia region only
provider "aws" {
  region = "us-east-1"
  alias = "certificateEligibleRegion"
}

terraform {
    # Optional
    # Terraform backend configuration. The state is stored in S3 bucket
    # The actions to do are calculated from a diff of current infra and backend state
    # Is read on the very early stage, so using variables are not allowed
    backend "s3" {
        key = "Website_Certificate/state.tfstate"
    }
}


resource "aws_acm_certificate" "web_site_certificate" {
  domain_name       = "${var.website_name}"
  validation_method = "DNS"

  provider = "aws.certificateEligibleRegion"

  subject_alternative_names = ["${var.website_name}", "www.${var.website_name}"]
}

data "aws_route53_zone" "web_site_zone" {
  name         = "${var.website_name}"
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.web_site_zone.zone_id}"
  records  = ["${aws_acm_certificate.web_site_certificate.domain_validation_options.0.resource_record_value}"]
  ttl      = 300
}
resource "aws_route53_record" "www_cert_validation" {
  name     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.1.resource_record_name}"
  type     = "${aws_acm_certificate.web_site_certificate.domain_validation_options.1.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.web_site_zone.zone_id}"
  records  = ["${aws_acm_certificate.web_site_certificate.domain_validation_options.1.resource_record_value}"]
  ttl      = 300
}


resource "aws_acm_certificate_validation" "web_site_certificate_validation" {
  provider = "aws.certificateEligibleRegion"

  certificate_arn         = "${aws_acm_certificate.web_site_certificate.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}", "${aws_route53_record.www_cert_validation.fqdn}"]
}