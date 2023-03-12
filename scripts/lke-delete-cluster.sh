#!/bin/bash

# Get cluster ID
ID=`linode-cli lke clusters-list --json | jq '.[0].id'`
echo [ℹ]  LKE Cluster has ID = $ID

# Delete LKE cluster
linode-cli lke cluster-delete $ID
echo [✔]  Cluster deleted