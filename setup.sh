#!/bin/sh

EXECUTOR=xargs

error_out () {
	local msg="$1"
	echo "$msg"
	exit 1
}

while getopts "p" opt
do
	case "$opt" in
		p) #-p runs in parallel mode
			EXECUTOR=parallel
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
	for bid in $(defects4j bids -p "$proj" -A)
	do
		proj_bids+=("$proj $bid")
	done
done

printf "%s\n" "${proj_bids[@]}" | "$EXECUTOR" -n2 bash -c 'bash run_single.sh $0 $1 &> logs/$0/$1.txt'
