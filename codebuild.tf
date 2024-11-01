resource "aws_codebuild_project" "backend_build" {
  name          = "${var.project_name}-backend-build"
  description   = "Build project for the backend Java Spring Boot application"
  service_role  = aws_iam_role.codebuild_service_role.arn
  build_timeout = 60

  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec.backend.yml")
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_MEDIUM"
    image           = "aws/codebuild/standard:5.0" # Java, Gradle, Docker pre-installed
    type            = "LINUX_CONTAINER"
    privileged_mode = true # Required for Docker builds
    # environment_variables = [
    #   {
    #     name  = "DOCKER_IMAGE"
    #     value = "${aws_ecr_repository.backend_repo.repository_url}:${var.docker_tag}"
    #   }
    # ]
  }
  # cache {
  #   type     = "S3"
  #   location = aws_s3_bucket.cache_bucket.bucket
  # }
}


resource "aws_codebuild_project" "frontend_build" {
  name          = "${var.project_name}-frontend-build"
  description   = "Build project for the frontend React application"
  service_role  = aws_iam_role.codebuild_service_role.arn
  build_timeout = 60
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec.frontend.yml")
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0" # Node, npm, Docker pre-installed
    type            = "LINUX_CONTAINER"
    privileged_mode = true # Required for Docker builds
    # environment_variables = [
    #   {
    #     name  = "DOCKER_IMAGE"
    #     value = "${aws_ecr_repository.frontend_repo.repository_url}:${var.docker_tag}"
    #   }
    # ]
  }
  # cache {
  #   type     = "S3"
  #   location = aws_s3_bucket.cache_bucket.bucket
  # }
}


resource "aws_codebuild_project" "test_build" {
  name         = "${var.project_name}-test"
  service_role = aws_iam_role.codebuild_service_role.arn
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0" # Use an appropriate image for your project
    type         = "LINUX_CONTAINER"
    # environment_variable {
    #   name  = "ENV_VAR_NAME"
    #   value = "value"  # Set any required environment variables
    # }
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = file("buildspec.test.yml")
  }
}


