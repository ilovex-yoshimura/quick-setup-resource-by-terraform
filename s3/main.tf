resource "aws_s3_bucket" "default" {
  bucket = "${var.prefix}-s3-bucket"
  acl = "private" 
  # バケットにオブジェクトが入っている時でも、terraform destroyで削除可能になる。
  # 何度かつくりなおしたい時にtrueに設定しておくと楽。
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = "allow connections from specific IPs"
    effect = "Allow"
    principals {
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
        test = "IpAddress"
        variable  = "aws:SourceIp"
        values = var.IPs
    }
  }
}