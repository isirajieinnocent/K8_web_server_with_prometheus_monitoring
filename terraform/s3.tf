#create bucket for statefile
resource "aws_s3_bucket" "my-webapp-terraform-state" 
bucket = "my-webapp-terraform-state"
  versioning {
    enabled = true
    dynamodb_table = aws_dynamodb_table.terraform_state_lock.name
    encrypt = true
  }

  lifecycle {
    prevent_destroy = true
  }
