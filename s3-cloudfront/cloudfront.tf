resource "aws_cloudfront_distribution" "default" {
    comment = "test for s3 accepting connections from only this cloudfront"
    enabled =  true

    origin {
        domain_name = aws_s3_bucket.default.website_endpoint
        origin_id = aws_s3_bucket.default.id
        custom_origin_config {
            http_port              = "80"
            https_port             = "443"
            origin_protocol_policy = "http-only"
            origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
        # s3_origin_config {
        #     origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
        # }
    }

    default_root_object = "index.html"

    default_cache_behavior {
        allowed_methods = [ "GET", "HEAD" ]
        cached_methods = [ "GET", "HEAD" ]
        target_origin_id = aws_s3_bucket.default.id
        
        forwarded_values {
            query_string = false
            cookies {
              forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }

    restrictions {
      geo_restriction {
          restriction_type = "none"
      }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}

resource "aws_cloudfront_origin_access_identity" "default" {}