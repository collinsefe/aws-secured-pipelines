terraform {
  backend "s3" {
    bucket = "terraform-tfstate-base-infra"
    key    = "devops/asp/codepipeline.tfstate"
    region = "eu-west-2"

  }
}

