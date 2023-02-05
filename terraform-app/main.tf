### Load Balancer ###
module "app_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name                = "${var.stage}-${var.app_name}-sg"
  description         = "Security group for ${var.app_name} application load balancer."
  vpc_id              = data.aws_vpc.vpc.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
}

resource "aws_lb" "app" {
  name               = "${var.stage}-${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.app_sg.security_group_id]
  subnets            = data.aws_subnets.public.ids
}

resource "aws_lb_target_group" "app" {
  name        = "${var.stage}-${var.app_name}-alb-tg"
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id

  health_check  {
    enabled = false
    protocol = "HTTP"
    port  = 80
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"   # Add ceritifacte
  protocol          = "HTTP" # Add ceritifacte
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

### ECS Resources ###

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.stage}-${var.app_name}-td-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name  = "${var.stage}-${var.app_name}-app-container"
      image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/simple-web-app:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ],
      environment = [
        {
          name  = "PORT"
          value = "80"
        }
      ],
    }
  ])
}

resource "aws_ecs_cluster" "app" {
  name = "${var.stage}-${var.app_name}"
}

resource "aws_ecs_service" "app" {
  name            = var.app_name
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = data.aws_subnets.private.ids
    security_groups = [module.app_sg.security_group_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.stage}-${var.app_name}-app-container"
    container_port   = 80
  }
}


