#!/bin/sh

# This script checks if there are landmark nodes in the diagnosis reports.

PROJS=(Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time)
CRITERIA=(default knn tree forest linear logistic xmeans)


get_node_ids () {
	local bug_dir="$1"
	local criteria="$2" 
	#prepend '.' if NOT empty so that empty string for criteria will check diagnosis.txt file
	[[ "$criteria" = "" ]] || criteria=".$criteria"
	[[ -f "$bug_dir/diagnosis$criteria.txt" ]] && { cut -d':' -f2 "$bug_dir/diagnosis$criteria.txt" | cut -d',' -f1; }
}

check_all_criteria () {
	local proj="$1"
	local bug="$2"
        for crit in ${CRITERIA[@]}
        do
		landmarks_in_diagnosis "$proj" "$bug" "$crit"
        done
}

#If the 3rd parameter is empty, the considered diagnosis file is diagnosis.txt
landmarks_in_diagnosis () {
	local proj="$1"
	local bug="$2"
	local crit="$3" #empty criteria checks diagnosis.txt
	node_ids=($(get_node_ids "data/$proj/$bug" "$crit"))
        for n_id in ${node_ids[@]}
        do
        	#grep "\"id\":$n_id,.*LANDMARK" data/$proj/$bug/landmarks.$crit.txt && { echo $proj $bug; break; }
		[[ "$crit" = "" ]] || crit=".$crit"
		landmark_node="$(grep "\"id\":$n_id,.*LANDMARK" data/$proj/$bug/nodes.txt)"
                [[ "$landmark_node" = "" ]] || echo "diagnosis$crit.txt: $landmark_node"
        done
}

for proj in ${PROJS[@]}
do
	if [[ -d data/$proj ]]
	then
	    for bug in $(ls data/$proj)
	    do
	        if [[ -d data/$proj/$bug ]]
		then
	    	    echo "- Analyzing $proj-$bug"
		    #check_all_criteria "$proj" "$bug"
		    landmarks_in_diagnosis "$proj" "$bug"
		fi
            done
	fi
done

