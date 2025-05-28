module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "adcash-project-vpc"
  cidr = "0.0.0.0/16"
  azs  = ["us-west-2a", "us-west-2b"]
  public_subnets = ["10.0.3.0/24", "10.0.2.0/24"]
  private_subnets =["10.0.102.0/24", "10.0.104.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project     = "adcash-project"
    Environment = "production"
  }
}

  

