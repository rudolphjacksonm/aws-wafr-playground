# AWS Well-Architected Tool Automation
This is a playground repo for automating the creation of AWS Well-Architected Framework resources. This is not currently supported in Terraform.

## Requirements
* Shellcheck
* awscli version `2.10.1`

## Setup
Simply clone the repo and configure your authentication mechanism with AWS (IAM identity center, SSO, Access Keys, etc). 

Create a config file in the `config/` directory, and ensure you update both scripts to point to your chosen config file. Run `create_workload.sh` to create a workload, and `create_milestone.sh` to create a milestone for the same workload.