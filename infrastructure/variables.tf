variable "project_name" {
  type    = string
  default = "trakdip"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"

}

variable "az_count" {
  type    = number
  default = 2

}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "postgres_user" {
  type    = string
  default = "psqladmin"
}

variable "api_port" {
  type    = string
  default = "80"
}

variable "api_protocol" {
  type    = string
  default = "HTTP"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}