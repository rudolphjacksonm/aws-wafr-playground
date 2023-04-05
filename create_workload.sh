#!/bin/bash
set -euo pipefail
source config/test_workload.env
source helpers/lib.sh

main() {
  # Create workload
  aws wellarchitected create-workload \
    --account-ids "${ACCOUNT_IDS}" \
    --architectural-design "${ARCHITECTURAL_DESIGN}" \
    --aws-regions "eu-west-1" "eu-west-2" \
    --description "${DESCRIPTION}" \
    --environment "${ENVIRONMENT}" \
    --industry "${INDUSTRY}" \
    --industry-type "${INDUSTRY_TYPE}" \
    --lenses $LENSES \
    --pillar-priorities $PILLAR_PRIORITIES \
    --review-owner "${REVIEW_OWNER}" \
    --workload-name "${WORKLOAD_NAME}"

  # Create SNS topic + subscription to NOTIFICATION_EMAIL
  create_sns_integration "${WORKLOAD_NAME}" "${NOTIFICATION_EMAIL}"
  
  # Create Lambda function

  # Create corresponding EventBridge rule
}

main