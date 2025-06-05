#create dynamdb table for statefile locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform_state_lock_webapp"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

