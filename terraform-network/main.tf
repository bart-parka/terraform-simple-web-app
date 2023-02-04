module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = "${var.stage}-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["${var.region}a", "${var.region}b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]     # 2 for High-Availability
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"] # 2 for High-Availability
  enable_nat_gateway = true
}

resource "aws_ecr_repository" "app" {
  name                 = "simple-web-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr-repo" {
  value = aws_ecr_repository.app.repository_url
}