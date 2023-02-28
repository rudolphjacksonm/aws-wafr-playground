#!/bin/bash
set -euo pipefail
# assuming MILESTONE_NAME is passed in via release pipeline
source config/test_workload.env
source helpers/lib.sh

main() {
  local milestoneName=$1
  local workloadId=$(get_workload_id "${WORKLOAD_NAME}")
  check_milestone "${workloadId}" "${milestoneName}"
  create_milestone  "${workloadId}" "${milestoneName}"
}

get_workload_id | main "${MILESTONE_NAME}"