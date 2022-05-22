module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  version = "2.9.3"
  # insert the 9 required variables here

  //aliases = ["cdn.example.com"]

  comment             = "Project NPA CloudFront"
  enabled             = true
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = false
  
  origin = {
    webELB = {
      domain_name =  aws_lb.webLB.dns_name
      origin_path = "/WebServerExample.php"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    
    }

    
  }

  default_cache_behavior = {
    target_origin_id           = "webELB"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

tags = merge(local.common_tags, { Name = "${var.cName}-cdn"})
}
