# Well-Architected Framework Guidance
## Requirements
### Workload Definition
Before defining workloads in AWS, engineers, architects, business analysts, and stakeholders should agree on the scope and boundary of a _workload_. A _workload_ in the AWS Well-Architected Framework (WAF) can be a subset of AWS services in a single account, or a collection of resources spanning multiple accounts.

### Frequency of Milestones
Agree as a group how often _milestones_ should be created. Workloads can have multiple _milestones_, which serve as point-in-time snapshots of the state of the workload against the Well-Architected Framework lens. 

Ideally, the creation of milestones would be bolted in to an existing release process and automated as much as possible. It may be more feasible in the immediate term to create milestones manually at a predefined interval, say every three to six months, or whenever the next pen test is scheduled.

### Granting Access to the Well-Architected Tool
Access to the Well-Architected Tool should be granted following the principle of least privilege. Guidance for giving users access can be found [here](https://docs.aws.amazon.com/wellarchitected/latest/userguide/iam-auth-access.html).

## Initialisation
### Automation is Key
The most sensible place to run the WAT (Well-Architected Tool) from is the root account. This allows central management of reviews that may or may not span across multiple accounts within AWS Organizations. As mentioned above--access to this account must be carefully managed and protected by following the principle of least privilege.

If the approach outlined above is followed, then the creation of workloads, milestones, lenses, and any other resources within the Well-Architected Tool should be done via an automated process.

### Use AppRegistry to Group Resources
Grouping resources across accounts or AWS services is crucial for success. You can link the ARN of an AppRegistry app to your workload. This is ideal for tracebility, especially if workloads are delineated by environment.

### Creating Workloads
Given CI/CD tooling is provisioned, a script can be plugged into a pipeline to create workloads in a simple, automated way.
```bash
#!/bin/bash
#---in a config file called workload.env
awsRegions='eu-west-1 eu-west-2'
accountIds='''
123456789012
123456789011
'''
applications='''
arn:aws:servicecatalog:us-east-1: XXXXXXXXXX:/application/0bwdgnibevsc5clgtm7hehuljh
'''
architecturalDesign='https://www.confluence.com'
description='Test application for using the Well-Architected Tool'
environment='PREPRODUCTION'
industry='Software'
industryType='InfoTech'
lenses='''
wellarchitected
serverless
'''
pillarPriorities='''
operationalExcellence
performance
security
reliability
costOptimization
sustainability
'''
reviewOwner='someone@example.com'
workloadName='waf-test-workload'
```
In the main script, the variables above can be sourced and used to create a workload.
```bash
#!/bin/bash
#---in main.sh
source config.env

function check_workload {
  local workloadNamePrefix=$1
  check=$(aws wellarchitected list-workloads --workload-name-prefix "${workloadNamePrefix}" | jq '.WorkloadSummaries[0].WorkloadId')
  if [[ "null" != "${check}" ]]; then
    echo "Workload with name $workloadNamePrefix already exists, exiting..."
    exit 
  fi
}

check_workload "${workloadName}"

aws wellarchitected create-workload \
--account-ids $accountIds \
--applications $applications \
--architectural-design $architecturalDesign \
--aws-regions $awsRegions \
--description $description \
--environment $environment \
--industry $industry \
--industry-type $industryType \
--lenses $lenses \
--pillar-priorities $pillarPriorities \
--review-owner $reviewOwner \
--workload-name $workloadName \
```

### Creating Milestones
Milestones can be created whenever a release is generated via the AWS CLI. This is recommended as milestone reports can then be generated.

```bash
#!/bin/bash
source config.env
aws wellarchitected list-workloads --workload-name-prefix "${workloadName}" --query 'WorkloadSummaries[].WorkloadId' --output text
aws wellarchitected create-milestone \
--workload-id "${workloadId}" \
--milestone-name <value> \
```

### Configuring Notifications
When a workload, milestone, or lens is created/modified/deleted, a notification should be sent. AWS EventBridge events are triggered whenever these actions occur, and SNS should be set up to send notifications to a predefined list.

## Workflow
The general process from start to finish could look something like this:
* Workload created in Well-Architected Tool via automated process
  * Workload shared with relevant accounts/OUs if required
* Initial review completed and milestone saved
* Reviews to be performed as part of regular cycle in delivery processes
  * Minimum recommendation of twice annually. Ideally perform this quarterly
* Milestone created when a product milestone has been reached, which can be any of the following:
  * major/minor release
  * first design document, before anything is deployed
  * first MVP
  * first push to production
  * time-based measurement (three or six monthly) 
  * number of registered users
  * financial goal reached
* EventBridge sends notification to SNS topic around milestone and relevant Improvement Plan findings at time of milestone creation
* Metrics could be scraped and integrated into QuickSight or PowerBI for dashboarding