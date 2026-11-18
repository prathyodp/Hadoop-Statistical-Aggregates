# Hadoop MapReduce Statistical Aggregates (Python + Hadoop Streaming)

## What this project does
Reads numerical records and calculates:
- Maximum
- Arithmetic average
- Exact distinct-value count

It also reports record count and sum to make the calculations easy to verify.

## Project files
- `dataset/numbers.txt` — sample input data (one number per line)
- `mapper.py` — Hadoop Streaming mapper
- `reducer.py` — Hadoop Streaming reducer
- `Project_Notebook.ipynb` — explanation, local test, manual verification, and Hadoop run template
- `Raw_Calculation_Sheet.xlsx` — raw inputs and expected calculations
- `run_local_windows.bat` — local Windows test
- `run_local_linux.sh` — local Linux/macOS test
- `hadoop_streaming_job.sh` — example Hadoop Streaming submission command (edit paths/version for your cluster)

## Expected result for the included sample
Input: 10, 20, 30, 20, 40, 50, 10, 60, 30, 80

- Record count = 10
- Sum = 350
- Maximum = 80
- Average = 35
- Distinct count = 7

## 1. Test locally on Windows
Install Python 3.8+ and open CMD in this project folder:

```cmd
python mapper.py < dataset\numbers.txt
python mapper.py < dataset\numbers.txt | sort | python reducer.py
```

Expected reducer output:
```text
Maximum    80
Average    35
Distinct_Count    7
Record_Count    10
Sum    350
```
(The values are tab-separated.)

## 2. Test locally on Linux/macOS
```bash
chmod +x mapper.py reducer.py run_local_linux.sh
./run_local_linux.sh
```

## 3. Run with Hadoop Streaming
The Hadoop cluster must be running, and the Hadoop Streaming JAR must be available. Upload the data:

```bash
hdfs dfs -mkdir -p /user/student/statistics/input
hdfs dfs -put -f dataset/numbers.txt /user/student/statistics/input/
hdfs dfs -rm -r -f /user/student/statistics/output
```

Find the Streaming JAR (the exact path/version depends on your Hadoop installation), then run a command similar to:

```bash
hadoop jar /path/to/hadoop-streaming.jar \
  -D mapreduce.job.reduces=1 \
  -files mapper.py,reducer.py \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py" \
  -input /user/student/statistics/input/numbers.txt \
  -output /user/student/statistics/output
```

Then view the result:
```bash
hdfs dfs -cat /user/student/statistics/output/part-00000
```

You can also edit and use `hadoop_streaming_job.sh`.

## Important scalability note
This teaching implementation uses one reducer so that it can calculate an exact global maximum, average, and distinct count in one job. The reducer keeps the distinct values in memory; for extremely high-cardinality data, this can consume substantial memory. A production-scale design would use multiple MapReduce stages (or a distributed distinct-count strategy) and merge partial sums/counts/maxima. The average must be calculated as total sum divided by total record count, not as an average of mapper averages.

## Input format
One numeric value per line. Blank lines are ignored. Non-numeric lines are skipped and reported to stderr.

## Notes for your submission
Replace or expand the sample dataset with your own test records if required by your instructor. Capture screenshots of:
1. HDFS input directory listing
2. Hadoop job execution / completion
3. HDFS output contents
4. Raw calculation sheet and matching MapReduce output
