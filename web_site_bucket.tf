resource "aws_s3_bucket" "web_site_bucket" {
  bucket = "s3-website-yuriiulianets.dev"
  acl    = "public-read"

  website {
    index_document = "Index.html"
    error_document = "Error.html"
  }

  force_destroy = true
}

resource "aws_s3_bucket_policy" "web_site_bucket_policy" {
  bucket = "${aws_s3_bucket.web_site_bucket.id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
      "Sid":"PublicReadGetObject",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.web_site_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}