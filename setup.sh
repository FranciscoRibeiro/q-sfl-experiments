#!/bin/sh

EXECUTOR="seq"

error_out () {
	local msg="$1"
	echo "$msg"
	exit 1
}

while getopts "p" opt
do
	case "$opt" in
		p) #-p runs in parallel mode
			EXECUTOR="par"
			;;
		*)
			error_out "Incorrect usage"
			;;
	esac
done

#Check Defects4J installation
which defects4j &> /dev/null || error_out "Defects4J not installed"

#Output active projects in Defects4J
PROJS=($(defects4j pids))

proj_bids=()
#For each project, collect active bug ids
for proj in ${PROJS[@]}
do
	mkdir -p logs/$proj
	for bid in $(defects4j bids -p "$proj")
	do
		proj_bids+=("$proj $bid")
	done
done

case "$EXECUTOR" in
	"seq")
		echo "Sequential"
		printf "%s\n" "${proj_bids[@]}" | xargs -n2 bash -c 'bash run_single.sh $0 $1 &> logs/$0/$1.txt'
		;;
	"par")
		echo "Parallel"
		printf "%s\n" "${proj_bids[@]}" | parallel -C ' ' "bash run_single.sh {1} {2} &> logs/{1}/{2}.txt"
		;;
esac
