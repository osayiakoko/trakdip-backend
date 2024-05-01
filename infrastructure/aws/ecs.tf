
# resource "aws_kms_key" "main" {
#   description             = "aws kms key"
#   deletion_window_in_days = 7
# }

# resource "aws_cloudwatch_log_group" "main" {
#   name = "${var.project_name}-cl_log_group-${var.environment}"
# }

#------------------------------------

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}_cluster_${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-ecs_cluster-${var.environment}"
  }
}

resource "aws_ecs_task_definition" "api_task" {
  family                   = "${var.project_name}-task-${var.environment}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name        = "${var.project_name}-api-${var.environment}"
      image       = "654654333412.dkr.ecr.us-east-1.amazonaws.com/trakdip:latest"
      cpu         = 1024
      memory      = 2048
      essential   = true
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 80
          hostPort      = var.api_port
          protocl       = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group" = "true",
          awslogs-group          = "/ecs/${var.project_name}-task-${var.environment}",
          awslogs-region         = var.region,
          awslogs-stream-prefix  = "ecs"
        }
      }
    }
  ])

  #   volume {
  #     name      = "service-storage"
  #     host_path = "/ecs/service-storage"
  #   }
}

resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  #   deployment_minimum_healthy_percent = var.ecs_task_deployment_minimum_healthy_percent
  #   deployment_maximum_percent         = var.ecs_task_deployment_maximum_percent

  load_balancer {
    target_group_arn = aws_lb_target_group.api_service.arn
    container_name   = "${var.project_name}-api-${var.environment}"
    container_port   = var.api_port
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_task.id]
    subnets          = [for subnet in aws_subnet.private : subnet.id]
    assign_public_ip = true
  }

  depends_on = [aws_lb_listener.api_service, aws_iam_role_policy_attachment.ecs_task_execution_attachment]

  lifecycle {
    ignore_changes = [desired_count]
  }
}
