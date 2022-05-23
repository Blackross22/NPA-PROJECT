##################################################################################
# OUTPUT
##################################################################################

output "aws_lb_public_dns" {
  value = aws_lb.webLB.dns_name
}

output "aws_cf_distribute_domain_name"{
  value = module.cdn.cloudfront_distribution_domain_name
}