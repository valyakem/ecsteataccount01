variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the DB parameter group"
  type        = string
  default     = "arcablanca-rds-group"
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = "arcablanca-postgres-rds"
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "postgres10"
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type        = any
    default ={
      "key"   = "name"
      "value" = "arcablanca-postgres-rds"
    }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {
    "name": "arcablanca-postgres-rds"
  }
}
