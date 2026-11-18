#!/usr/bin/env python3

import sys

# Hadoop Streaming Reducer

numbers = []

for line in sys.stdin:

    key, value = line.strip().split("\t")

    numbers.append(float(value))

if numbers:

    maximum = max(numbers)

    total = sum(numbers)

    count = len(numbers)

    average = total / count

    distinct_count = len(set(numbers))

    print("Maximum: {}".format(maximum))

    print("Average: {}".format(average))

    print("Distinct Count: {}".format(distinct_count))