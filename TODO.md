# TODO
## Typos/Bugs
* In `create_workload.sh`, `--aws-regions` does not properly parse sourced variable due to quotation marks.
## Features
* Creation of EventBridge rules for each workload
* Creation of Lambda to create custom notifications
* Test creation of SNS to handle sending of reports
## Everything else
* Split repo into two directories, one purely AWSCLI and another using Terraform + local-exec where possible?
## Prereqs to remember
* Must configure a trail in CloudTrail; default capturing of Event History isn't enough to trigger EventBridge
* Lambda needs permissions to read Well Architected Tool and `sns:Publish` for the topic