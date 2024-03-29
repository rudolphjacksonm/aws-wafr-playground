import json
import os
import boto3

sns = boto3.client('sns')
wellarch = boto3.client('wellarchitected')
topic_arn = os.environ['TOPIC_ARN']
print(topic_arn)
def lambda_handler(event, context):
    #Extract details from JSON event
    account_id = event["account"]
    function_name = context.function_name
    milestone_name = event['detail']['requestParameters']['MilestoneName']
    region = event["region"]
    workload_id = event['detail']['requestParameters']['WorkloadId']

    milestone_details = wellarch.get_milestone(
      WorkloadId=event['detail']['requestParameters']['WorkloadId'],
      MilestoneNumber=event['detail']['responseElements']['MilestoneNumber']
    )
    
    print(milestone_details)

    workload_name = milestone_details['Milestone']['Workload']['WorkloadName']
    risk_counts = milestone_details['Milestone']['Workload']['RiskCounts']

    message = '''
    Milestone %s created in region %s for account: %s
    Workload Name: %s
    Workload ID: %s
    Risk Counts: %s
    Generated by function: %s
    ''' % (milestone_name, region, account_id, workload_name, workload_id, risk_counts, function_name)
    
    publish = sns.publish(
            TopicArn = topic_arn,
            Message = message
            )
    return {
      'statusCode': 200,
      'body': json.dumps('Notification sent!')
    }
