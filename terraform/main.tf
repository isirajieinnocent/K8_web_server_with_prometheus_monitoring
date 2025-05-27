#get vpc data
data "aws_vpc" "default" {
  default = true
}

#get public subnet
data "aws_subnet" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
#provision eks cluster
resource "aws_eks_cluster" "webapp" {
  name     = "webapp"
  role_arn = aws_iam_role.webapp.arn

  vpc_config {
    subnet_ids = [data.aws_subnet.public.id]
  }



  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.webapp-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.webapp-AmazonEKSVPCResourceController,
  ]
}
