#This solution, non-production-ready template describes AWS Codepipeline based CICD Pipeline for terraform code deployment.
#© 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
#This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
#http://aws.amazon.com/agreement or other written agreement between Customer and either
#Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


#Module for creating a new S3 bucket for storing pipeline artifacts
module "video_artifacts_bucket" {
  source                = "./modules/s3"
  project_name          = var.project_name_video
  kms_key_arn           = module.codepipeline_kms.arn
  codepipeline_role_arn = module.codepipeline_iam_role.role_arn
  tags = {
    Project_Name = var.project_name_video
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}


# Module for Infrastructure Validation - CodeBuild
module "codebuild_terraform_video" {
  # depends_on = [
  #   module.codecommit_infrastructure_source_repo
  # ]
  source = "./modules/codebuild"

  project_name                        = var.project_name_video
  role_arn                            = module.codepipeline_iam_role.role_arn
  s3_bucket_name                      = module.video_artifacts_bucket.bucket
  build_projects                      = var.build_projects
  build_project_source                = var.build_project_source
  builder_compute_type                = var.builder_compute_type
  builder_image                       = var.builder_image
  builder_image_pull_credentials_type = var.builder_image_pull_credentials_type
  builder_type                        = var.builder_type
  kms_key_arn                         = module.codepipeline_kms_video.arn
  tags = {
    Project_Name = var.project_name_video
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}

module "codepipeline_kms_video" {
  source                = "./modules/kms"
  codepipeline_role_arn = module.codepipeline_iam_role.role_arn
  tags = {
    Project_Name = var.project_name_video
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }

}

module "codepipeline_iam_role_video" {
  source                     = "./modules/iam-role"
  project_name               = var.project_name_video
  create_new_role            = var.create_new_role
  codepipeline_iam_role_name = var.create_new_role == true ? "${var.project_name_video}-codepipeline-role" : var.codepipeline_iam_role_name
  source_repository_name     = var.source_repo_name
  kms_key_arn                = module.codepipeline_kms.arn
  s3_bucket_arn              = module.s3_artifacts_bucket.arn
  tags = {
    Project_Name = var.project_name_video
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}
# Module for Infrastructure Validate, Plan, Apply and Destroy - CodePipeline
module "codepipeline_terraform_video" {
  depends_on = [
    module.codebuild_terraform_video,
    module.video_artifacts_bucket
  ]
  source = "./modules/codepipeline"

  project_name          = var.project_name_video
  source_repo_name      = var.source_repo_name
  source_repo_branch    = var.source_repo_branch
  s3_bucket_name        = module.s3_artifacts_bucket.bucket
  codepipeline_role_arn = module.codepipeline_iam_role.role_arn
  stages                = var.stage_input
  kms_key_arn           = module.codepipeline_kms_video.arn
  source_provider       = var.source_provider
  codestar_name         = var.codestar_name
  tags = {
    Project_Name = var.project_name_video
    Environment  = var.environment
    Account_ID   = local.account_id
    Region       = local.region
  }
}

