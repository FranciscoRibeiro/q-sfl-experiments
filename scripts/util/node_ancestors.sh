#!/bin/sh

# This script lists the node ancestors of a specific node.
# Input:
# 1. Node ID
# 2. File with nodes to search

NODE_ID="$1" #Expected to change through the iterations
NODES_FILE="$2"

get_node_info () {
	local node_id="$1"
	local nodes_file="$2"
	grep "\"id\":$node_id," $nodes_file
}

get_parent_id () {
	local node_id="$1"
	local nodes_file="$2"
	echo $(get_node_info $node_id $nodes_file) | jq '.parentId'
}

while [[ "$NODE_ID" -ne 0 ]]
do
	get_node_info "$NODE_ID" "$NODES_FILE"
        NODE_ID=$(get_parent_id "$NODE_ID" "$NODES_FILE")
done
