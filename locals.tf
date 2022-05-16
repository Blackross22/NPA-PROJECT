locals {
  common_tags = {
    itclass = var.itclass
    type = var.type
  }

  cName = var.cName
  s3_bucket_name = "${var.bucket_name_prefix}-npa-${random_integer.rand.result}"
}