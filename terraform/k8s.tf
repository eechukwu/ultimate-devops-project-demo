# Retrieve EKS cluster authentication information
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# Configure Kubernetes provider to use the EKS cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# EKS Module (as in previous example)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

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

# aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
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
    ])
  }
}