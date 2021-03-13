output "host" {
  value = module.rds.this_db_instance_address
}

output "port" {
  value = module.rds.this_db_instance_port
}

output "database" {
  value = module.rds.this_db_instance_name
}

output "username" {
  value     = module.rds.this_db_instance_username
  sensitive = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}
