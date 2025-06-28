resource "aws_s3_bucket" "s3_bucket" {
  bucket = "luiscarlosjp-bucket-iac"

  tags = {
    Name = "First Bucket"
    Iac = true
  }
}
