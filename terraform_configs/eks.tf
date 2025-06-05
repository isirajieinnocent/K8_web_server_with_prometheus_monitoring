
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  subnet_ids         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_name    = "adcash-project"
  cluster_version = "1.31"
  create_iam_role = false
  iam_role_arn    = aws_iam_role.adcash-project.arn
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    eks_nodes = {
      desired_size   = 2
      max_capacity   = 3
      min_capacity   = 1

      instance_types   = ["t3.medium"]
      capacity_type  = "SPOT"
      additional_tags = {
        Name = "eks_nodes"
      }
    }
  }


  tags = {
    Project     = "adcash-project"
    Environment = "production"
  }
}