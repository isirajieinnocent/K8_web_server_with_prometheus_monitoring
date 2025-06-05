resource "aws_iam_role" "adcash-project" {
    name = "eks-cluster-adcash-project-role"
    assume_role_policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "eks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    })
}
  
  resource "aws_iam_role_policy_attachment" "adcash-project-AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.adcash-project.name
  }

  resource "aws_iam_role_policy_attachment" "adcash-project-AmazonEKSVPCResourceController" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role       = aws_iam_role.adcash-project.name
  }


  #Node Group IAM Role
  resource "aws_iam_role" "adcash-project-node-group" {
    name = "eks-node-group-adcash-project-role"
  
    assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
  }
  resource "aws_iam_role_policy_attachment" "adcash-project-node-group-AmazonEKSWorkerNodePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.adcash-project-node-group.name
  }
  resource "aws_iam_role_policy_attachment" "adcash-project-node-group-AmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.adcash-project-node-group.name
  }
  resource "aws_iam_role_policy_attachment" "adcash-project-node-group-AmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.adcash-project-node-group.name
  }
  resource "aws_iam_role_policy_attachment" "adcash-project-node-group-AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.adcash-project-node-group.name
  }