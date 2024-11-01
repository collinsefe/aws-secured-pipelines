

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "capgem-codebuild-artifact-${var.environment}"

  #   versioning {
  #     enabled = true
  #   }


#   #   lifecycle_rule {
#   #     id      = "expire-old-versions"
#   #     enabled = true

#   #     noncurrent_version_expiration {
#   #       days = 30  
#   #     }
#   #   }

  tags = {
    Name        = "Artifact Bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "artifact_bucket_pab" {
  bucket = aws_s3_bucket.artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "cache_bucket" {
  bucket = "capgem-codebuild-cache-${var.environment}"


  #   versioning {
  #     enabled = true
  #   }


  tags = {
    Name        = "Cache Bucket"
    Environment = "dev"
  }
}


resource "aws_s3_bucket_public_access_block" "cache_bucket_pab" {
  bucket = aws_s3_bucket.cache_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
   statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
  

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.project_name}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.artifact_bucket.arn,
      "${aws_s3_bucket.artifact_bucket.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github_connection.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "${var.project_name}-codepipeline-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}




# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["codepipeline.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# # resource "aws_iam_role" "codepipeline_role" {
# #   name               = "codepipeline-test-role"
# #   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# # }

# # data "aws_iam_policy_document" "codepipeline_policy" {
# #   statement {
# #     effect = "Allow"

# #     actions = [
# #       "s3:GetObject",
# #       "s3:GetObjectVersion",
# #       "s3:GetBucketVersioning",
# #       "s3:PutObjectAcl",
# #       "s3:PutObject",
# #     ]

# #     resources = [
# #       aws_s3_bucket.artifact_bucket.arn,
# #       "${aws_s3_bucket.artifact_bucket.arn}/*"
# #     ]
# #   }

# #   statement {
# #     effect    = "Allow"
# #     actions   = ["codestar-connections:UseConnection"]
# #     resources = [aws_codestarconnections_connection.github.arn]
# #   }

# #   statement {
# #     effect = "Allow"

# #     actions = [
# #       "codebuild:BatchGetBuilds",
# #       "codebuild:StartBuild",
# #     ]

# #     resources = ["*"]
# #   }
# # }

# # resource "aws_iam_role_policy" "codepipeline_policy" {
# #   name   = "codepipeline_policy"
# #   role   = aws_iam_role.codepipeline_role.id
# #   policy = data.aws_iam_policy_document.codepipeline_policy.json
# # }

