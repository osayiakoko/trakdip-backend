# resource "aws_secretsmanager_secret" "postgres_sm" {
#   name = "${var.project_name}-${var.environment}-secretss"

#   tags = {
#     Name = "${var.project_name}-postgres-sm-${var.environment}"
#   }
# }
