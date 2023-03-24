data "aws_iam_policy_document" "wellarch_lambda" {
  statement {
    sid    = "ReadWellArchitectedTool"
    effect = "Allow"

    actions = [
      "wellarchitected:Get*",
      "wellarchitected:List*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SnsPublish"
    effect = "Allow"

    actions   = ["sns:Publish"]
    resources = [module.sns_topic.topic_arn]
  }
}