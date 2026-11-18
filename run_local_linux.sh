#!/usr/bin/env bash
set -euo pipefail
python3 mapper.py < dataset/numbers.txt | sort | python3 reducer.py
