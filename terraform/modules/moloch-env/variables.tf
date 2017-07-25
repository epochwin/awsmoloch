
# Stores current account and user data
data "aws_caller_identity" "current" {}

resource "random_id" "bucket_uuid" {
  byte_length = 8
}

variable "aws_region" {
  description = "AWS Region"
}

variable "aws_key_name" {
  description = "SSH Key Name"
}

variable "private_key_path" {
  description = "Path to Private SSH Key"
}

variable "pcap_s3_bucket" {
  description = "S3 Bucket for PCAP storage"
  default = "pcap_bucket"
}

variable "environment_name" {
  default = "testing"
}

variable "vpc_cidr" {
  description = "VPC netblock"
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "VPC private subnet"
  default = "10.0.0.0/24"
}

variable "private_viewer_ip" {
  description = "Moloch Viewer Private IP"
  default = "10.0.0.15"
}

variable "private_capture_ip" {
  description = "Moloch Capture Private IP"
  default = "10.0.0.16"
}

variable "viewer_ami" {
  description = "Current Moloch Viewer AMI"
}

variable "moloch_instance_type" {
  description = "Moloch Instance Type"
  default = "t2.medium"
}

variable "capture_ami" {
  description = "Current Moloch Capture AMI"
}

variable "web_instance_type" {
  description = "Web Instance Type"
  default = "t2.medium"
}

data "template_file" "capture_config" {
  template = "${file("${path.module}/conf/capture-config.tpl")}"

  vars {
    aws_region        = "${var.aws_region}"
    s3_bucket         = "${aws_s3_bucket.pcap_bucket.bucket}"
    moloch_access_id  = "${aws_iam_access_key.moloch_capture.id}"
    moloch_secret_key = "${aws_iam_access_key.moloch_capture.secret}"
    viewer_private    = "${var.private_viewer_ip}"
  }
}

data "template_file" "viewer_config" {
  template = "${file("${path.module}/conf/viewer-config.tpl")}"

  vars {
    aws_region        = "${var.aws_region}"
    s3_bucket         = "${aws_s3_bucket.pcap_bucket.bucket}"
    moloch_access_id  = "${aws_iam_access_key.moloch_viewer.id}"
    moloch_secret_key = "${aws_iam_access_key.moloch_viewer.secret}"
    viewer_private    = "${var.private_viewer_ip}"
  }
}
