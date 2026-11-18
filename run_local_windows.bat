@echo off
setlocal
python mapper.py < dataset\numbers.txt | sort | python reducer.py
endlocal
