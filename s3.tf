resource "random_integer" "rand" {
  min = 100
  max = 9999
}

resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
 
  force_destroy = true

 

  tags = merge(local.common_tags, { Name = "${var.cName}-web-bucket" })
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "website" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "index.html"
  //source = "./website/index.html"

  tags = local.common_tags

}


