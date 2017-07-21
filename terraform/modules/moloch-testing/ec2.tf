resource "aws_instance" "moloch" {
    ami = "${var.viewer_ami}"
    availability_zone = "${var.aws_region}a"
    instance_type = "${var.moloch_instance_type}"
    iam_instance_profile = "moloch-test"
    key_name = "${var.aws_key_name}"
    subnet_id = "${aws_subnet.private.id}"
    private_ip = "${var.private_viewer_ip}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = "true"

    provisioner "remote-exec" {
      inline = [
        "sudo tee /etc/elasticsearch/elasticsearch.yml <<EOF",
        "network.host: ${var.private_viewer_ip}",
        "EOF",
        "sudo systemctl start elasticsearch.service",
        "sudo tee /data/moloch-nightly/etc/config.ini <<EOF",
        "${data.template_file.viewer_config.rendered}",
        "EOF",
        "sleep 30",
        "sudo systemctl reset-failed molochviewer.service",
        "sudo systemctl start molochviewer.service"
      ]

      connection {
        type        = "ssh"
        user        = "centos"
        private_key = "${file("~/Downloads/slapula.pem")}"
      }
    }

    tags {
      Name = "moloch_instance-${var.environment_name}"
      Environment = "${var.environment_name}"
      Role = "moloch"
    }
}

resource "aws_instance" "web" {
    ami = "${var.capture_ami}"
    availability_zone = "${var.aws_region}a"
    instance_type = "${var.web_instance_type}"
    iam_instance_profile = "moloch-test"
    key_name = "${var.aws_key_name}"
    subnet_id = "${aws_subnet.private.id}"
    private_ip = "${var.private_capture_ip}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address  = "true"

    provisioner "remote-exec" {
      inline = [
        "sudo tee /data/moloch-nightly/etc/config.ini <<EOF",
        "${data.template_file.capture_config.rendered}",
        "EOF",
        "sleep 30",
        "sudo systemctl reset-failed molochcapture.service",
        "sudo systemctl start molochcapture.service",
      ]

      connection {
        type        = "ssh"
        user        = "centos"
        private_key = "${file("~/Downloads/slapula.pem")}"
      }
    }

    tags {
      Name = "web_instance-${var.environment_name}"
      Environment = "${var.environment_name}"
      Role = "web"
    }
}
