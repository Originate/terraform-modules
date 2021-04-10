variable "sql_database" {
  description = "The name of the SQL database"
  type        = string
}

# Since most variables are defined at the stack-level, putting them in a map
# avoids having to repeatedly thread them individually through multiple modules
variable "attributes" {
  description = "A map of attributes for creating an RDS database"
  type = object(
    {
      # The name of the stack
      stack = string
      # The name of the environment
      env = string
      # Default tags to add to AWS resources
      default_tags = map(string)
      # The ID of the VPC
      vpc_id = string
      # The list of IDs to place the EKS cluster and workers
      subnet_ids = list(string)
      # A list of security group IDs that are allowed to access the instance
      allowed_security_group_ids = list(string)
      # The RDS instance class type
      instance_class = string
      # The allocated storage in gibibytes
      allocated_storage = number
      # Specifies if the RDS instance is multi-AZ
      multi_az = bool
      # The number of days to retain backups
      backup_retention_period = number
      # Enable RDS Enhanced Monitoring metrics
      enable_enhanced_monitoring = bool
      # Disable deletion of the RDS instance
      enable_delete_protection = bool
      # Determines whether a final DB snapshot is created before the DB instance is deleted
      skip_final_snapshot = bool
    }
  )

  validation {
    condition     = var.attributes.allocated_storage >= 20 && var.attributes.allocated_storage <= 65536
    error_message = "The allocated_storage value must be between 20 and 65,536 GiB, inclusive."
  }

  validation {
    condition     = var.attributes.backup_retention_period >= 0 && var.attributes.backup_retention_period <= 35
    error_message = "The backup_retention_period value must be between 0 and 35 days, inclusive."
  }
}
