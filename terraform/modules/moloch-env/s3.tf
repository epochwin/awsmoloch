resource "aws_s3_bucket" "pcap_bucket" {
  bucket = "${var.pcap_s3_bucket}_${random_id.bucket_uuid.dec}"
  acl    = "private"

  lifecycle_rule {
    enabled = true
    prefix = "/"
    noncurrent_version_expiration {
      days = 30
    }
  }

  tags {
    Name = "${var.pcap_s3_bucket}"
    Environment = "${var.environment_name}"
    Role = "storage"
  }
}
