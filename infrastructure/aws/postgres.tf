# resource "random_password" "postgres_password" {
#   length           = 16
#   special          = true
#   override_special = "$%&*[]{}<>"
# }

# resource "aws_db_instance" "postgres_db" {
#   instance_class            = "db.t3.micro"
#   identifier                = "${var.project_name}-database-${var.environment}"
#   allocated_storage         = 20
#   max_allocated_storage     = 100
#   engine                    = "postgres"
#   engine_version            = "16.1"
#   username                  = var.postgres_user
#   password                  = random_password.postgres_password.result
#   db_name                   = "${var.project_name}_db"
#   storage_type              = "gp3"
#   skip_final_snapshot       = startswith(var.environment, "prod") ? false : true
#   final_snapshot_identifier = "${var.project_name}-db-backup-${var.environment}"
#   backup_retention_period   = 7
#   publicly_accessible       = true


#   timeouts {
#     create = "3h"
#     delete = "3h"
#     update = "3h"
#   }

#   tags = {
#     Name = "${var.project_name}-postgress-db-${var.environment}"
#   }
# }

# resource "aws_secretsmanager_secret_version" "postgres_password" {
#   secret_id = aws_secretsmanager_secret.postgres_sm.id
#   secret_string = jsonencode({
#     "POSTGRES_HOST" : aws_db_instance.postgres_db.address,
#     "POSTGRES_PORT" : aws_db_instance.postgres_db.port,
#     "POSTGRES_DB" : aws_db_instance.postgres_db.db_name,
#     "POSTGRES_USER" : var.postgres_user,
#     "POSTGRES_PASSWORD" : random_password.postgres_password.result,
#   })
#   # depends_on = [aws_db_instance.postgres_db, ]
# }

# # resource "aws_db_instance" "postgres_db_replica" {
# #   identifier          = "${var.project_name}-database-replica-${var.environment}"
# #   replicate_source_db = aws_db_instance.postgres_db.identifier
# #   instance_class      = "db.t3.micro"
# #   apply_immediately   = true
# #   publicly_accessible = true
# #   skip_final_snapshot = true
# #   #  vpc_security_group_ids = [aws_security_group.postgres_db.id]
# #   #  parameter_group_name   = aws_db_parameter_group.example.name
# # }

