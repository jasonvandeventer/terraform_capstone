resource "aws_kms_key" "cloudtrail" {
  description             = "KMS key for CloudTrail"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "cloudtrail-kms-policy",
    Statement : [
      {
        Sid : "Allow CloudTrail to use the key",
        Effect : "Allow",
        Principal : {
          Service : "cloudtrail.amazonaws.com"
        },
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy",
          "kms:ListResourceTags",
          "kms:GetKeyRotationStatus",
          "kms:ListAliases"
        ],
        Resource : "*"
      },
      {
        Sid : "Allow account admins full access",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action : "kms:*",
        Resource : "*"
      }
    ]
  })
}

resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/cloudtrail-key"
  target_key_id = aws_kms_key.cloudtrail.key_id
}