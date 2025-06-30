data "aws_s3_bucket" "bucket" {
  bucket = "luiscarlosjp-bucket-iac-${terraform.workspace}"
}
