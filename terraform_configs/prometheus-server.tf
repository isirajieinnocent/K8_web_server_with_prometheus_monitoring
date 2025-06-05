# 1. Get default VPC information
data "aws_vpc" "default" {
  default = true
}

# 2. Get default subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 3. Create key pair (using your existing public key)
resource "aws_key_pair" "prometheus_key" {
  key_name   = "prometheus_key"
  public_key = file("~/.ssh/prometheus_key.pub") # Ensure this file exists
}

# 4. Create security group in default VPC
resource "aws_security_group" "example" {
  name        = "prometheus_sg"
  description = "Allow prometheus server and SSH traffic"
  vpc_id      = data.aws_vpc.default.id # Uses default VPC

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Create EC2 instance in default VPC
resource "aws_instance" "prometheus_server" {
  ami           = "ami-084568db4383264d4" # Ubuntu 22.04 in us-east-1
  instance_type = "t3.medium"
  key_name      = aws_key_pair.prometheus_key.key_name
  
  # Use first default subnet
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "prometheus_server"
  }
}