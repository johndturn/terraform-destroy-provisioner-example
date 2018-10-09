provider "aws" {
  version = "~> 1.35"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "example-bucket" {
  bucket = "example.bucket.1234.56789"
  acl    = "private"

  provisioner "local-exec" {
    command = "sh post-receipts-bucket-creation.sh"

    environment {
      BUCKET = "example.bucket.1234.56789"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "sh pre-receipts-bucket-destroy.sh"

    environment {
      BUCKET = "example.bucket.1234.56789"
    }
  }

  tags {
    Name        = "Example Bucket"
    Environment = "demo"
  }
}
