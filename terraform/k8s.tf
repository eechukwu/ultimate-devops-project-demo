module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = local.name
  cluster_version               = local.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Temporarily disable aws-auth management
  manage_aws_auth_configmap = false

  eks_managed_node_groups = {
    general = {
      desired_size = 3
      max_size     = 6
      min_size     = 2

      instance_types = ["t2.medium"]
    }
  }

  tags = local.tags
}