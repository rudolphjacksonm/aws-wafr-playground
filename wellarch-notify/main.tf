module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = local.prefix
  retention_in_days = local.log_retention
}

module "sns_topic" {
  source = "terraform-aws-modules/sns/aws"
  name   = "${local.prefix}-notify"
  subscriptions = {
    email = {
      protocol = local.sns_protocol
      endpoint = var.sns_endpoint
    }
  }
  tags = var.tags
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  attach_policy_json = true
  function_name      = "${local.prefix}-formatter"
  description        = local.lambda_description
  handler            = local.lambda_handler
  policy_json        = data.aws_iam_policy_document.wellarch_lambda.json
  runtime            = local.lambda_runtime
  source_path        = local.lambda_src_path

  environment_variables = {
    TOPIC_ARN = module.sns_topic.topic_arn
  }

  tags = var.tags
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  rules = {
    wellarchitected = {
      description = "Capture events for Well Architected Tool"
      event_pattern = jsonencode({
        "detail" : { "eventName" : ["CreateMilestone"] }
        "source" : ["aws.wellarchitected"]
      })
      enabled = true
    }
  }
  targets = {
    wellarchitected = [
      {
        name = "send-to-lambda"
        arn  = module.lambda_function.lambda_function_arn
      },
      {
        name = "log-to-cloudwatch"
        arn  = module.log_group.cloudwatch_log_group_arn
      }
    ]
  }

  tags = var.tags
}