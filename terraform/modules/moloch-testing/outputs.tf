output "viewer_public_dns" {
  value = "${aws_instance.moloch.public_dns}"
}

output "capture_public_dns" {
  value = "${aws_instance.web.public_dns}"
}

output "viewer_public_ip" {
  value = "${aws_instance.moloch.public_ip}"
}

output "capture_public_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "viewer_access_id" {
  value = "${aws_iam_access_key.moloch_viewer.id}"
}

output "viewer_secret_key" {
  value = "${aws_iam_access_key.moloch_viewer.secret}"
}

output "capture_access_id" {
  value = "${aws_iam_access_key.moloch_capture.id}"
}

output "capture_secret_key" {
  value = "${aws_iam_access_key.moloch_capture.secret}"
}
