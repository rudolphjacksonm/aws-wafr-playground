variable "sns_endpoint" {
  type        = string
  default     = "someone@example.com"
  description = "The endpoint which received SNS notifications."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to resources created by this module."
  type        = map(string)
  default     = {}
}