#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
# mkdir ci_test/config

#test config
cp config/example/* config/
cp tools/ci/ci_dbconfig.txt config/dbconfig.txt

cd ci_test
DreamDaemon cev_eris.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
