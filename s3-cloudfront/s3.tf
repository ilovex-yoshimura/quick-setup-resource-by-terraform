resource "aws_s3_bucket" "default" {
  bucket = "${var.prefix}-s3-bucket"
  acl = "private" 
  # バケットにオブジェクトが入っている時でも、terraform destroyで削除可能になる。
  # 何度かつくりなおしたい時にtrueに設定しておくと楽。
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  } 
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = "allow connections from specific cloudfront"
    effect = "Allow"
    principals {
        # type = "AWS"
        # identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
        type = "*"
        identifiers = ["*"]
    }
    actions = [
        "s3:getObject"
    ]
    resources = [
        "${aws_s3_bucket.default.arn}/*"
    ]
    condition {
        test = "StringEquals"
        variable  = "aws:UserAgent"
        values = ["Amazon CloudFront"]
    }
  }
}

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.default.id
  key = "index.html"
  source = "static/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "www_index" {
  bucket = aws_s3_bucket.default.id
  key = "www/index.html"
  source = "static/www/index.html"
  content_type = "text/html"
}