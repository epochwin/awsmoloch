resource "aws_iam_user" "moloch_viewer" {
  name = "moloch_viewer"
  path = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "moloch_viewer"{
  user = "${aws_iam_user.moloch_viewer.name}"
}

resource "aws_iam_policy_attachment" "viewer-attach" {
  name       = "viewer-attachment"
  users      = ["${aws_iam_user.moloch_viewer.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "moloch_capture" {
  name = "moloch_capture"
  path = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "moloch_capture"{
  user = "${aws_iam_user.moloch_capture.name}"
}

resource "aws_iam_policy" "moloch_capture" {
  name        = "moloch_capture_policy"
  description = "moloch_capture_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.pcap_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.pcap_bucket.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "capture-attach" {
  name       = "capture-attachment"
  users      = ["${aws_iam_user.moloch_capture.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  #policy_arn = "${aws_iam_policy.moloch_capture.arn}"
}
