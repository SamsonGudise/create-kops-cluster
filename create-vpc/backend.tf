terraform {
  backend "s3" {
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}