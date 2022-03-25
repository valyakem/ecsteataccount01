variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = "arcablanca-rds-subnet-group"
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = true
}

variable "description" {
  description = "The description of the DB subnet group"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {
    "name": "arcablanca-subnet-group"
  }
}
