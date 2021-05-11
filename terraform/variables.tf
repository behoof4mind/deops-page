variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 4000
}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests"
  type        = number
  default     = 443
}

variable "app_version" {
  description = "DevopsPage application version"
  default     = "0.1.0"
}

variable "mysql_username" {
  description = "Mysql RDS username"
  default     = "root"
}

variable "mysql_password" {
  description = "Mysql RDS user password"
  default     = "mysqlpass"
}

variable "env_prefix" {
  description = "Environment prefix"
  default     = "test"
}

variable "is_temp_env" {
  description = "Boolean to differentiate prod/test environment"
  default     = false
}

variable "max_ec2_instances" {
  description = "Max number of EC2 instances in aws_autoscaling_group"
  type        = number
  default     = 1
}

variable "min_ec2_instances" {
  description = "Min number of EC2 instances in aws_autoscaling_group"
  type        = number
  default     = 1
}


