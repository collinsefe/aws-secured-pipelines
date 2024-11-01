resource "aws_codestarconnections_connection" "github_connection" {
  name          = "my-github-connection"
  provider_type = "GitHub"
}

# data "aws_kms_alias" "s3kmskey" {
#   name = "alias/myKmsKey"
# }