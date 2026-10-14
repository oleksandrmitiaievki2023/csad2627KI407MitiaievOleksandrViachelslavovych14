#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d .venv ]]; then
    python3 -m venv .venv
fi

if [[ ! -x .venv/bin/python ]]; then
    printf '%s\n' 'The existing .venv has no usable Python interpreter.' >&2
    exit 1
fi

.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python src/hello.py