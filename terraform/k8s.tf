module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Manage aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.eks_admin_role.arn
      username = "eks-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = aws_iam_role.eks_developer_role.arn
      username = "eks-developer"
      groups   = ["developer"]
    },
    {
      rolearn  = aws_iam_role.eks_readonly_role.arn
      username = "eks-readonly"
      groups   = ["readonly"]
    }
  ]

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