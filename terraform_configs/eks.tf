module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_name    = "adcash-project"
  cluster_version = "1.31"
}

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type   = "t3.medium"
      capacity_type  = "Spot"
      key_name        = var.key_name
      additional_tags = {
        Name = "eks_nodes"
      }
    }
  }
  tags = {
    Project     = "adcash-project"
    Environment                        = "production"
  }