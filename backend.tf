# backend.tf 
terraform { 
  backend "s3" { 
    bucket  = "seu-bucket-tfstate"  
    key     = "site/terraform.tfstate" 
    region  = "us-east-1"
    encrypt = true
  }
}
