// Create a VPC for the Fargate service
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

// Create an Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

// Create two subnets in different Availability Zones for the Fargate service
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" // Change to your desired AZ
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" // Change to a different AZ
}

// Create a security group for the Fargate service
resource "aws_security_group" "api_sg" {
  vpc_id = aws_vpc.main.id

  // Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow HTTP traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Route table association  
resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.custom_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.custom_route_table.id
}

// Create an IAM role for ECS tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "ecsTaskExecutionPolicy"
  role = aws_iam_role.ecs_task_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "*"
        # Resource  = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

// Attach an IAM policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

// Create an ECS cluster for the Fargate service
resource "aws_ecs_cluster" "main" {
  name = "api-cluster"
}

// Create an ECS task definition for the API service
resource "aws_ecs_task_definition" "api_task" {
  family                   = "api-service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn // Assign the ECS task execution role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"  // Define CPU at the task level for Fargate
  memory                   = "1024" // Define memory at the task level for Fargate
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name        = "${var.project_name}",
      image       = "654654333412.dkr.ecr.us-east-1.amazonaws.com/trakdip:latest",
      cpu         = 512
      memory      = 1024
      essential   = true
      networkMode = "awsvpc"
      portMappings = [
        {
          #   name          = "nginx-80-tcp"
          containerPort = 80
          hostPort      = 80
          protocl       = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group" = "true",
          awslogs-group          = "/ecs/api-service",
          awslogs-region         = "us-east-1",
          awslogs-stream-prefix  = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = 2 // Change to your desired number of tasks
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    security_groups  = [aws_security_group.api_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_target_group.arn
    container_name   = var.project_name
    container_port   = 80
  }

  depends_on = [aws_lb_listener.api_listener, aws_iam_role_policy_attachment.ecs_task_execution_attachment]
}

// Create a load balancer for the Fargate service
resource "aws_lb" "api_lb" {
  name               = "api-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  security_groups    = [aws_security_group.api_sg.id]

  enable_deletion_protection = false
}

// Create a target group for the load balancer
resource "aws_lb_target_group" "api_target_group" {
  name        = "api-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path     = "/"
    protocol = "HTTP"
    port     = "traffic-port"
  }
}

// Create a listener for the load balancer
resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_target_group.arn
  }
}

// Create a CloudFront distribution
resource "aws_cloudfront_distribution" "api_cloudfront" {
  origin {
    domain_name = aws_lb.api_lb.dns_name
    # origin_id = aws_lb.api_lb.dns_name
    origin_id = "${aws_lb.api_lb.name}-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = ""

  default_cache_behavior {
    # target_origin_id =  aws_lb.api_lb.dns_name
    target_origin_id = "${aws_lb.api_lb.name}-origin"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "PATCH", "POST", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    # Using the CachingDisabled managed policy ID:
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    # Using the AllViewer managed policy ID:
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


// Output the ECS task definition ARN and load balancer DNS name
output "task_definition_arn" {
  value = aws_ecs_task_definition.api_task.arn
}

output "load_balancer_dns" {
  value = aws_lb.api_lb.dns_name
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.api_cloudfront.domain_name
}
