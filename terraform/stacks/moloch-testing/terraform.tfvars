terragrunt {
  remote_state {
    backend  = "s3"
    config {
      encrypt     = true
      bucket      = "moloch-testing-tfstate"
      key         = "terraform.tfstate"
      region      = "us-east-1"
      lock_table  = "moloch-testing-tfstate"
    }
  },
  terraform {
    source = "../../modules/moloch-testing"
  }
}

aws_region    = "us-east-1"
capture_ami   = "ami-XXXXXXXX"
viewer_ami    = "ami-XXXXXXXX"
