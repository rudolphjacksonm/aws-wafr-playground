#!/bin/bash
get_workload_id() {
  local workloadNamePrefix=${1:-null}
  workloadId=$(aws wellarchitected list-workloads --workload-name-prefix "${workloadNamePrefix}" --query "WorkloadSummaries[0].WorkloadId" --output text)
  if [[ "${workloadId}" == "None" ]] || [[ "${workloadId}" == "null" ]]; then
    echo "No workload with prefix ${workloadNamePrefix} exists."
    exit 1
  else
    echo "${workloadId}"
  fi
}

check_milestone() {
  local workloadId=${1-null}
  local milestoneName={$2-null}
  check=$(aws wellarchitected list-milestones --workload-id "${workloadId}" --query "MilestoneSummaries[?MilestoneName=='$milestoneName']" --output text)
  if [[ -n "${check}" ]]; then
    echo "Milestone ${milestoneName} already exists for workload with ID ${workloadId}."
    exit 1
  fi
}

create_milestone() {
  local workloadId=${1-null}
  local milestoneName=${2-null}
  aws wellarchitected create-milestone --workload-id "${workloadId}" --milestone-name "${milestoneName}"
}