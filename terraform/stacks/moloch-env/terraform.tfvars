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

aws_region      = "us-east-1"
aws_key_name    = "slapula"
#pcap_s3_bucket  = ""
capture_ami     = "ami-58451623"
viewer_ami      = "ami-994516e2"
