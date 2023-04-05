locals {
  # Common
  prefix = "wellarchitected"
  
  # CloudWatch
  log_retention = 0

  # Lambda function
  lambda_description = "Function for receiving EventBridge events from Well-Architected Tool"
  lambda_handler     = "lambda_function.lambda_handler"
  lambda_src_path    = "../src/lambda_function.py"
  lambda_runtime     = "python3.9"

  # SNS
  sns_protocol = "email"
}