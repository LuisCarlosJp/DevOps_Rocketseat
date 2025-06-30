resource "aws_s3_bucket" "s3_bucket" {
  bucket = "luiscarlosjp-bucket-iac-${terraform.workspace}"

  tags = {
    Name = "First Bucket"
    Iac = true
    context = "${terraform.workspace}"
  }
}
