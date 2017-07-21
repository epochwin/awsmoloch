resource "aws_s3_bucket" "pcap_bucket" {
  bucket = "moloch_${var.environment_name}_pcaps"
  acl    = "private"

  lifecycle_rule {
    enabled = true
    prefix = "/"
    noncurrent_version_expiration {
      days = 30
    }
  }

  tags {
    Name = "moloch_${var.environment_name}_pcaps"
    Environment = "${var.environment_name}"
    Role = "storage"
  }
}
