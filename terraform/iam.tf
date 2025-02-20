# IAM roles and policies for EKS cluster access management
# This file defines IAM roles and policies to grant access to the EKS cluster based on IAM groups

data "aws_caller_identity" "current" {}

# EKS Admin Role
resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = {
    Environment = "prod"
  }
}

# EKS Developer Role
resource "aws_iam_role" "eks_developer_role" {
  name = "eks-developer-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = {
    Environment = "prod"
  }
}

# EKS Read-only Role
resource "aws_iam_role" "eks_readonly_role" {
  name = "eks-readonly-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = {
    Environment = "prod"
  }
}

# EKS Admin Policy
resource "aws_iam_policy" "eks_admin_policy" {
  name        = "eks-admin-policy"
  path        = "/"
  description = "Policy for assuming eks-admin-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:*",
          "ec2:*",
          "iam:*",
          "cloudwatch:*",
          "autoscaling:*",
          "logs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "prod"
  }
}

# EKS Developer Policy
resource "aws_iam_policy" "eks_developer_policy" {
  name        = "eks-developer-policy"
  path        = "/"
  description = "Policy for assuming eks-developer-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi",
          "ssm:GetParameter"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "prod"
  }
}

# EKS Read-only Policy
resource "aws_iam_policy" "eks_readonly_policy" {
  name        = "eks-readonly-policy"
  path        = "/"
  description = "Policy for assuming eks-readonly-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "prod"
  }
}

# Attach EKS Admin Policy to EKS Admin Role
resource "aws_iam_role_policy_attachment" "eks_admin_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_admin_policy.arn
  role       = aws_iam_role.eks_admin_role.name
}

# Attach EKS Developer Policy to EKS Developer Role
resource "aws_iam_role_policy_attachment" "eks_developer_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_developer_policy.arn
  role       = aws_iam_role.eks_developer_role.name
}

# Attach EKS Read-only Policy to EKS Read-only Role
resource "aws_iam_role_policy_attachment" "eks_readonly_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_readonly_policy.arn
  role       = aws_iam_role.eks_readonly_role.name
}

# Attach EKS Admin Policy to EKS Admins Group
resource "aws_iam_group_policy_attachment" "eks_admins_policy_attachment" {
  group      = "eks-admins"
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

# Attach EKS Developer Policy to EKS Developers Group
resource "aws_iam_group_policy_attachment" "eks_developers_policy_attachment" {
  group      = "eks-developers"
  policy_arn = aws_iam_policy.eks_developer_policy.arn
}

# Attach EKS Read-only Policy to EKS Read-only Group
resource "aws_iam_group_policy_attachment" "eks_readonly_policy_attachment" {
  group      = "eks-readonly"
  policy_arn = aws_iam_policy.eks_readonly_policy.arn
}