terraform {
  backend "s3" {
    bucket         = "myapp-static-content-bucket"   # Same bucket
    key            = "terraform/uat/terraform.tfstate" # Different path
    region         = "ap-south-1"
    encrypt        = true
  }
}
