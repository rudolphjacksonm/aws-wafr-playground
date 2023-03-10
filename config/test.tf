resource "aws_wellarchitected_workload" "this" {
  account_ids = [
    "123456789012",
    "123456789011",
  ]
  architectural_design = var.architectural_design
  aws_regions = [
    "eu-west-1",
    "eu-west-2",
  ]
  description  = var.description
  environment  = var.environment
  industry     = var.industry
  industryType = var.industryType
  lenses = [
    "wellarchitected",
    "serverless"
  ]
  pillar_priorities = [
    "operationalExcellence",
    "performance",
    "security",
    "reliability",
    "costOptimization",
    "sustainability",
  ]
  review_owner  = var.review_owner
  workload_name = var.workload_name
}

data "aws_wellarchitetected_workload" "this" {
  workload_id = aws_wellarchitected_workload.this.id
}