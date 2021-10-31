provider "aws" {
  alias  = "bucket_region"
  region = var.s3_bucket_region_name
}

resource "aws_s3_bucket" "web_servers_logs_bucket" {
  provider = aws.bucket_region
  bucket   = lower("${var.purpose_tag}-${var.s3_logs_bucket_name}")
  acl      = "private"

  force_destroy = true

  tags = {
    Name = lower("${var.purpose_tag}-${var.s3_logs_bucket_name}")
  }
}