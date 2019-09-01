resource "aws_route53_zone" "web_site_zone" {
  name = "${var.project_name}"
  force_destroy = true
}


/*
resource "aws_route53_record" "record_direct" {
  zone_id = "${aws_route53_zone.web_site_zone.zone_id}"
  name    = "${var.project_name}"
  type    = "A"

  alias {
      name = "${aws_s3_bucket.web_site_bucket.website_domain}"
      zone_id = "${aws_s3_bucket.web_site_bucket.hosted_zone_id}"
      evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_www" {
  zone_id = "${aws_route53_zone.web_site_zone.zone_id}"
  name    = "www.${var.project_name}"
  type    = "A"

  alias {
      name = "${aws_s3_bucket.www_web_site_bucket.website_domain}"
      zone_id = "${aws_s3_bucket.www_web_site_bucket.hosted_zone_id}"
      evaluate_target_health = false
  }
}*/


output "Nameservers" {
  value = "${aws_route53_zone.web_site_zone.name_servers}"
}
