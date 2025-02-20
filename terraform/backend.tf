terraform {
  backend "s3" {
    bucket         = "demo-terraform-eks-state-bucket-eec-lab"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}