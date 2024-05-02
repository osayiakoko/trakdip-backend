// Create an IAM role for ECS tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ecs_task_exection_role-${var.environment}"
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

// Create an IAM role policy for logs actions
resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "${var.project_name}-ecs_task_exection_policy-${var.environment}"
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
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



// ECS auto scale role
resource "aws_iam_role" "ecs_autoscaling_role" {
  name = "${var.project_name}-autoscaling_role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "application-autoscaling.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecs_autoscaling_policy" {
  name = "${var.project_name}-autoscaling_tag_policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "application-autoscaling:TagResource",
          "application-autoscaling:ListTagsForResource"
        ],
        Resource = "*"
        #  Resource = "arn:aws:application-autoscaling:*:*:scalable-target/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "autoscaling_policy_attachment" {
  role       = aws_iam_role.ecs_autoscaling_role.name
  policy_arn = aws_iam_policy.ecs_autoscaling_policy.arn
}
