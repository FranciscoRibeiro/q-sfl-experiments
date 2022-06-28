#!/usr/bin/sh
project=$1
bug_id=$2

echo "started $project $i" >> log.txt
python3 scripts/main.py $project $bug_id
echo "finished $project $i" >> log.txt
