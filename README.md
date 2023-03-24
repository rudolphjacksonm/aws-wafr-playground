# AWS Well-Architected Tool Automation
This is a playground repo for automating the creation of AWS Well-Architected Framework resources. This is not currently supported in Terraform.

## Requirements
* Shellcheck (for linting bash functions)
* awscli version `2.10.1`
* terraform version `~v1.2.7`

## Setup
1. Clone the repo and configure your authentication mechanism with AWS (IAM identity center, SSO, Access Keys, etc).
2. Run the supplied terraform code in the `waf-notifications/` directory to create the following resources:
  * Lambda function
  * SNS topic
  * IAM policies for Lambda function
  * EventBridge rule
  * CloudWatch Log Group for EventBridge
3. Once you've configured your notification infrastructure, you are ready to create your first _workload_ in the Well-Architected Tool.
4. Upon creating a _milestone_ in the Well-Architected Tool, a notification will be sent to the email address supplied to `sns_endpoint` in Terraform.

Create a config file in the `config/` directory, and ensure you update both scripts to point to your chosen config file. Run `create_workload.sh` to create a workload, and `create_milestone.sh` to create a milestone for the same workload.