#!/usr/bin/env python3

import sys

# Hadoop Streaming Mapper

for line_number, line in enumerate(sys.stdin, start=1):

    value = line.strip()

    if not value:
        continue

    try:
        number = float(value)

    except ValueError:
        print("Skipping invalid input: {}".format(value),
              file=sys.stderr)
        continue

    print("ALL\t{:.15g}".format(number))