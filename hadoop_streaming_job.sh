#!/usr/bin/env bash
# Update STREAMING_JAR if needed for your Hadoop distribution.
set -euo pipefail
STREAMING_JAR="${STREAMING_JAR:-/path/to/hadoop-streaming.jar}"
HDFS_INPUT="/user/student/statistics/input"
HDFS_OUTPUT="/user/student/statistics/output"

hdfs dfs -mkdir -p "$HDFS_INPUT"
hdfs dfs -put -f dataset/numbers.txt "$HDFS_INPUT/"
hdfs dfs -rm -r -f "$HDFS_OUTPUT" || true

hadoop jar "$STREAMING_JAR" \
  -D mapreduce.job.reduces=1 \
  -files mapper.py,reducer.py \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py" \
  -input "$HDFS_INPUT/numbers.txt" \
  -output "$HDFS_OUTPUT"

hdfs dfs -cat "$HDFS_OUTPUT/part-00000"
