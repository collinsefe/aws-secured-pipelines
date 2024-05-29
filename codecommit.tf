resource "aws_codecommit_repository" "test" {
  repository_name = "MyTestRepository"
  description     = "This is the Sample App Repository"
  kms_key_id      = aws_kms_key.demo.arn
}

resource "aws_kms_key" "demo" {
  description             = "demo kms keye                                                                                                                                                                                                                                                                                                                                                                                                                                                     333"
  deletion_window_in_days = 7
}