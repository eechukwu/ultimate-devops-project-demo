terraform {
  backend "s3" {
    bucket         = "eec-2025-tf-projects-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}