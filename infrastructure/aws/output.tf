output "nat_gateway_ip" {
  description = "Public ip for nat gateway"
  value       = aws_nat_gateway.nat_gw.*.public_ip
}

output "load_balancer_dns" {
  value = aws_lb.api_service.dns_name
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.api_cloudfront.domain_name
}
