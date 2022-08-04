#!/bin/sh

# This script checks if there are landmark nodes in the diagnosis reports.

#PROJS=(Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time)
PROJS=(Chart Closure Lang)
CRITERIA=(default knn tree forest linear logistic xmeans)

get_node_ids () {
	local bug_dir="$1"
	local criteria="$2"
	[[ -f "$bug_dir/diagnosis.$criteria.txt" ]] && { cut -d':' -f2 "$bug_dir/diagnosis.$criteria.txt" | cut -d',' -f1; }
}

for proj in ${PROJS[@]}
do
	for bug in $(ls data/$proj)
	do
		for crit in ${CRITERIA[@]}
		do
			node_ids=($(get_node_ids "data/$proj/$bug" "$crit"))
			for n_id in ${node_ids[@]}
			do
				grep "\"id\":$n_id," data/$proj/$bug/landmarks.$crit.txt && { echo $proj $bug; break; }
			done
		done
        done
done

