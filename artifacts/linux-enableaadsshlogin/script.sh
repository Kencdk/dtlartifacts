#!/bin/bash
function finish {
    echo "FAILED AT $(date)"
}
trap finish EXIT

managed_identity="$1"
virtualmachine_resourceid="$2"
echo "Using $managed_identity"
echo "Targeting $virtualmachine_resourceid"
start_time=$(date +%s)
echo "Current time : $(date)"
az login --identity --username $managed_identity
echo "Current time : $(date)"
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
echo "Elapsed seconds: $elapsed"

echo "Enable extension"

start_time=$(date +%s)
echo "Current time : $(date)"
az vm extension set -n AADSSHLoginForLinux --publisher Microsoft.Azure.ActiveDirectory --ids $virtualmachine_resourceid
echo "Current time : $(date)"
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
echo "Elapsed seconds: $elapsed"