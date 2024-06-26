project_name       = "supando"
environment        = "demo"
source_repo_name   = "corighose/itsnwe-aws-account-001"
source_repo_branch = "master"
create_new_repo    = false

repo_approvers_arn = "arn:aws:iam::684361860346:role/code-approvers" #arn:aws:iam::684361860346:group/pipeline-approvers*" #Update ARN (IAM Role/User/Group) of Approval Members
create_new_role    = true
#codepipeline_iam_role_name = <Role name> - Use this to specify the role name to be used by codepipeline if the create_new_role flag is set to false.
stage_input = [
  { name = "validate", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "SourceOutput", output_artifacts = "ValidateOutput" },
  { name = "plan", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "ValidateOutput", output_artifacts = "PlanOutput" },
  { name = "apply", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "PlanOutput", output_artifacts = "ApplyOutput" },
  { name = "destroy", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "ApplyOutput", output_artifacts = "DestroyOutput" }
]
build_projects = ["validate", "plan", "apply", "destroy"]
