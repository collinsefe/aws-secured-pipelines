resource "aws_codepipeline" "my_pipeline" {
  name     = "Java-React-Pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      provider         = "CodeStarSourceConnection"
      owner            = "AWS"
      version          = "1"
      output_artifacts = ["SourceOutput"]
         configuration = {
            ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
            FullRepositoryId = "collinsefe/capgem-app"
            BranchName       = "main"
      }
     }
    }
  

  stage {
    name = "Build"

    action {
      name     = "Build-Backend"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BackendBuildOutput"]
      configuration = {
        ProjectName = aws_codebuild_project.backend_build.name
      }
    }

    action {
      name     = "Build-Frontend"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["FrontendBuildOutput"]
      configuration = {
        ProjectName = aws_codebuild_project.frontend_build.name
      }
    }
  }

  stage {
    name = "Test"

    action {
      name             = "RunTests"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["BackendBuildOutput"] # or "SourceOutput" if tests are based on source
      output_artifacts = ["TestOutput"]
      configuration = {
        ProjectName = aws_codebuild_project.test_build.name
      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name     = "DeployBackend"
      category = "Deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = "1"

      input_artifacts = ["BackendBuildOutput"]
      configuration = {
        ClusterName = var.backend_cluster_name
        ServiceName = var.backend_service_name
        # TaskDefinition  = "${var.environment}-backend-task"
      }
    }

    action {
      name     = "DeployFrontend"
      category = "Deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = "1"

      input_artifacts = ["FrontendBuildOutput"]
      configuration = {
        ClusterName = var.frontend_cluster_name
        ServiceName = var.frontend_service_name
        # TaskDefinition  = "${var.environment}-frontend-task"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"
}

