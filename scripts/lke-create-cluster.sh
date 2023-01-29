#!/bin/bash

# Create LKE cluster
linode-cli lke cluster-create \
  --label mycluster \
  --region eu-central \
  --k8s_version 1.25 \
  --node_pools.type g6-standard-2 --node_pools.count 1 \
  --tags demo