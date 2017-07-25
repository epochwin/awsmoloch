terragrunt {
  remote_state {
    backend  = "s3"
    config {
      encrypt     = true
      bucket      = "moloch-env-tfstate"
      key         = "terraform.tfstate"
      region      = "us-east-1"
      lock_table  = "moloch-env-tfstate"
    }
  },
  terraform {
    source = "../../modules/moloch-env"
  }
}

aws_region        = "us-east-1"
aws_key_name      = ""
private_key_path  = ""
pcap_s3_bucket    = ""
capture_ami       = "ami-XXXXXXXX"
viewer_ami        = "ami-XXXXXXXX"
