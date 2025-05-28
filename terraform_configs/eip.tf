
resource "aws_eip" "adcash_webapp_eip" {
  count = 1
  vpc   = true

  tags = {
    Name = "adcash-webapp-eip"
  }
}