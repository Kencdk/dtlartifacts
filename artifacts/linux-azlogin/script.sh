#!/bin/bash
managed_identity="$1"
echo "Using $managed_identity"
start_time=$(date +%s)
echo "Current time : $(date)"
az login --identity --username $managed_identity
echo "Current time : $(date)"
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
echo "Elapsed seconds: $elapsed"