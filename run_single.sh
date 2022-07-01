#!/usr/bin/sh
project=$1
bug_id=$2

# Function to stop the container, i.e. docker kill, if it times out
# Also logs the situation and exits
container_timeout () {
	docker kill $(docker ps -a -q)
	docker rm $(docker ps -a -q)
	echo "container timed out $project $bug_id" >> log.txt
	exit 1
}

calculations_timeout () {
	echo "calculations timed out $project $bug_id" >> log.txt
	exit 1
}

SECONDS=0
echo "started $project $bug_id" >> log.txt
python3 scripts/main.py $project $bug_id

# main.py handles its own timeout, i.e. the 'timeout' command is not invoked here.
# The container does not stop appropriately using the 'timeout' command without sending the KILL signal
[[ "$?" -eq 124 ]] && container_timeout
docker rm $(docker ps -a -q)

timeout 10m python3 scripts/calculations.py $project $bug_id
[[ "$?" -eq 124 ]] && calculations_timeout

echo "finished $project $bug_id" >> log.txt
echo $SECONDS >> logs/$project/$bug_id.txt
