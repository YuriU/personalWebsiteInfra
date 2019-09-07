
output "Nameservers" {
  value = "${aws_route53_zone.web_site_zone.name_servers}"
}