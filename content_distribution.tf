resource "aws_cloudfront_distribution" "www_distribution" {

  # Making delay until the Certificate is validated
  depends_on = [ "aws_acm_certificate_validation.web_site_certificate_validation" ]
  
  origin {
    
    custom_origin_config {
      # Default settings
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = "${aws_s3_bucket.web_site_bucket.website_endpoint}"
    
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
    acm_certificate_arn = "${aws_acm_certificate.web_site_certificate.arn}"
    ssl_support_method  = "sni-only"
  }
}