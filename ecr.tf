resource "aws_ecr_repository" "k5s_ecr" {
  name                 = "k5s_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}