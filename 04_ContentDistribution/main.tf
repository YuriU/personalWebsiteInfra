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
        bucket = "jerryhire8test1-terraform-state-storage-bucket"
        key = "personalWebsite_ContentDistribution/state.tfstate"
        region = "eu-central-1"
        dynamodb_table = "personalWebsite_deploy_lock"
    }
}

data "aws_s3_bucket" "web_site_bucket" {
  bucket = "${var.project_name}"
}

data "aws_acm_certificate" "web_site_certificate" {
  provider = "aws.certificateEligibleRegion"
  domain   = "${var.project_name}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "web_site_zone" {
  name         = "${var.project_name}"
  private_zone = false
}

resource "aws_cloudfront_distribution" "www_distribution" {
  origin {
    
    custom_origin_config {
      # Default settings
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "${data.aws_s3_bucket.web_site_bucket.website_endpoint}"
    
    origin_id   = "S3-${var.project_name}"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    target_origin_id       = "S3-${var.project_name}"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # Aliases to be served
  aliases = ["${var.project_name}", "www.${var.project_name}"]

  # USA, Canada and Europe
  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    acm_certificate_arn = "${data.aws_acm_certificate.web_site_certificate.arn}"
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "record_direct" {
  zone_id = "${data.aws_route53_zone.web_site_zone.zone_id}"
  name    = "${var.project_name}"
  type    = "A"

  alias {
      name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
      zone_id = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
      evaluate_target_health = false
  }
}

resource "aws_route53_record" "record_www" {
  zone_id = "${data.aws_route53_zone.web_site_zone.zone_id}"
  name    = "www.${var.project_name}"
  type    = "A"

  alias {
      name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
      zone_id = "${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
      evaluate_target_health = false
  }
}