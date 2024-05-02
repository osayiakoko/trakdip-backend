# resource "aws_security_group" "database_sg" {
#   name        = "allow_database"
#   description = "Allow Database inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "${var.project_name}-database-sg-${var.environment}"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_postgres" {
#   security_group_id = aws_security_group.database_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 5432
#   ip_protocol       = "tcp"
#   to_port           = 5432
# }


resource "aws_security_group" "load_balancer" {
  name        = "${var.project_name}-load-balancer-sg-${var.environment}"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-load_balancer-${var.environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound" {
  security_group_id = aws_security_group.load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "ecs_task" {
  name        = "${var.project_name}-allow_tls-${var.environment}"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-ecs_task-${var.environment}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ecs_task.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.api_port
  ip_protocol       = "tcp"
  to_port           = var.api_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecs_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
