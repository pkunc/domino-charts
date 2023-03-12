#!/bin/bash

# Get cluster ID
ID=`linode-cli lke clusters-list --json | jq '.[0].id'`
echo [ℹ]  LKE Cluster has ID = $ID

# Download kubeconfig file
linode-cli --json lke kubeconfig-view $ID | jq -r '.[].kubeconfig | @base64d' > ~/.kube/lke.yml
echo [✔]  KubeConfig file downloaded and stored as ~/.kube/lke.yml