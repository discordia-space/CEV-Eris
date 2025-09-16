#!/bin/bash

set -euo pipefail
python -m tools.ci.od_annotator "$@"
