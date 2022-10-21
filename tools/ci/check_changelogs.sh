#!/bin/bash
set -euo pipefail

# md5sum -c - <<< "f7e6ca6705adbc0eb85fc381221557c4 *html/changelogs/example.yml"
python3 tools/changelog/ss13_genchangelog.py html/changelogs
