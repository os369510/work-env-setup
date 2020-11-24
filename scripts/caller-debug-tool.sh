#!/bin/bash

set -x

echo "-----------$(date)-----------" | sudo tee -a /var/log/jeremy-test.log
echo "whoami: $(whoami)" | sudo tee -a /var/log/jeremy-test.log
echo "commands: $0 $*" | sudo tee -a /var/log/jeremy-test.log
echo "pstree:" | sudo tee -a /var/log/jeremy-test.log
pstree -H $$ | sudo tee -a /var/log/jeremy-test.log
echo "" | sudo tee -a /var/log/jeremy-test.log

"${0}-real" "$@" | sudo tee -a /var/log/jeremy-test.log
