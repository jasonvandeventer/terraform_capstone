data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "cloudtrail_logs" {
  count         = var.low_cost ? 0 : 1
  bucket        = "jv-capstone-cloudtrail-logs"
  force_destroy = true

  tags = {
    Name = "cloudtrail-logs"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_logs" {
  count  = var.low_cost ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}


resource "aws_s3_bucket_ownership_controls" "cloudtrail_logs" {
  count  = var.low_cost ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_s3_bucket_policy" "cloudtrail_logs" {
  count  = var.low_cost ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs[0].arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}


resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  count  = var.low_cost ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  versioning_configuration {
    status = "Enabled"
  }
}


# CloudTrail (disabled in low_cost mode)
resource "aws_cloudtrail" "main" {
  count                         = var.low_cost ? 0 : 1
  name                          = "capstone-trail"
  s3_bucket_name                = var.low_cost ? null : aws_s3_bucket.cloudtrail_logs[0].id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = {
    Name = "capstone-trail"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  count  = var.low_cost ? 0 : 1
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.cloudtrail.arn
    }
  }
}
