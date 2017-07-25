# Moloch on AWS
Testing AWS packet capture with Moloch

# Requirements

To implement this configuration, you will need the latest versions of the following:

* Ansible
* Terraform
* Terragrunt
* Packer
* awscli

# Creating Moloch AMIs

1. `cd packer`
2. Build AMIs for both capture and viewer nodes:
* For viewer nodes: `packer-io build moloch-viewer.json`
* For capture nodes: `packer-io build moloch-capture.json`
3. Each command will output a new AMI id.  You will want to set the appropriate variable with its respective AMI id in `terraform/stacks/moloch-env/terraform.tfvars`.

# Creating the Infrastructure

1. `cd terraform/stacks/moloch-env/`
2. Adjust the `aws_region` and `aws_key_name` parameters in `terraform.tfvars` to your AWS environment  
3. `terragrunt get`
4. `terragrunt plan`
5. `terragrunt apply`

# Accessing the Viewer node

If everything finishes successfully, you will see a number of different outputs at the end of your Terragrunt run. You can log into the viewer node by going to the `viewer_public_dns` address on port 8005.  The default username/password is admin/test1234.  I would recommend changing that when you first log in.
