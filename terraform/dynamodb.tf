module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "demo-terraform-eks-state-bucket-eec-lab"
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"  # Changed from userID to match the hash_key
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging-tf-code"
  }
}