
resource "aws_instance" "prometheus_server" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t3.medium"
  key_name  = 
  vpc_sercurity_group_ids [            ]

}

   tags {
    name: "prometheus_server"
   }

   resource "aws_security_group" "example" {
    name        = "prometheus_sg"
    description = "Allow prometheus server  and SSH traffic"
    vpc_id      = aws_vpc.my_vpc.id
   }
    
    ingress {
      from_port        = 9090
      to_port          = 9090
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

    
    ingress {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }





  