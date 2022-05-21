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
  key    = "WebServerExample.php"
  source = "./WebServerExample.php"

  tags = local.common_tags

}
resource "aws_s3_object" "picIT" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "it-image.png"
  source = "./it-logo.png"

  tags = local.common_tags

}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}


data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.web_bucket.arn,
      "${aws_s3_bucket.web_bucket.arn}/*",
    ]
  }
}

