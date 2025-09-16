#!/bin/bash

set -euo pipefail
python -m tools.ci.dm_annotator "$@"
