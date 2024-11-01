# DOCKER_IMAGE: Image name in ECR for both frontend and backend.
# AWS_REGION: AWS region where ECR and other resources are set up.
# AWS_ACCOUNT_ID: Your AWS account ID.




variable "DOCKER_IMAGE" {
  description = "Unique name for this project"
  type        = string
  default     = "value"
}

variable "AWS_REGION" {
  description = "Whether to create a new repository. Values are true or false. Defaulted to true always."
  type        = string
  default     = "eu-west-2"
}

variable "AWS_ACCOUNT_ID" {
  description = "Whether to create a new IAM Role. Values are true or false. Defaulted to true always."
  type        = string
  default     = "8973536392722"
}



variable "backend_cluster_name" {
  default = "backend-ecs-cluster"
}

variable "frontend_cluster_name" {
  type    = string
  default = "frontend-ecs-cluster"
}


variable "backend_service_name" {
  default = "backend-ecs-service"
}

variable "frontend_service_name" {
  type    = string
  default = "frontend-ecs-service"
}

variable "gitlab_owner" {
  type    = string
  default = "cloud-devops-assignments"
}

variable "gitlab_token" {
  type    = string
  default = "value"
}

variable "gitlab_repo" {
  type    = string
  default = "https://gitlab.com/cloud-devops-assignments/spring-boot-react-example.git"
}



variable "github_owner" {
  type    = string
  default = "cloud-devops-assignments"
}

variable "github_token" {
  type    = string
  default = "value"
}

variable "github_repo" {
  type    = string
  default = "https://gitlab.com/cloud-devops-assignments/spring-boot-react-example.git"
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
}


variable "project_name" {
  type = string
}


variable "source_repository_name" {
  type = string
}

variable "source_repository_branch" {
  type = string
}

