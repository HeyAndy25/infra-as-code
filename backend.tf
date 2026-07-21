# state.tf 
terraform { 
  backend "s3" { 
    bucket = "terraform-state-anderson-estudo"  
    key     = "site/terraform.tfstate" 
    region = "us-east-2"
    encrypt = true
  }
}