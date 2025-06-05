#create bucket for statefile
resource "aws_s3_bucket" "my-webapp-terraform-state" {
  bucket = "my-webapp-terraform-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
