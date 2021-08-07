#!/bin/bash
set -euo pipefail

# ordering. we still need to drop names in the config folder
mkdir ci_test/config
tools/deploy.sh ci_test

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt

cd ci_test
DreamDaemon cev_eris.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
