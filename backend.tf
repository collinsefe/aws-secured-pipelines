terraform {
  backend "s3" {
    bucket = "terraform-tfstate-0030004072"
    key    = "devops/agw/codepipeline.tfstate"
    region = "eu-west-2"
  }
}
