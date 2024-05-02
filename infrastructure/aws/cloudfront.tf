
// Create a CloudFront distribution
resource "aws_cloudfront_distribution" "api_cloudfront" {
  origin {
    domain_name = aws_lb.api_service.dns_name
    origin_id   = "${aws_lb.api_service.name}-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "${lower(var.api_protocol)}-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = ""

  default_cache_behavior {
    target_origin_id = "${aws_lb.api_service.name}-origin"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    # Using the CachingDisabled managed policy ID:
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    # Using the AllViewer managed policy ID:
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
