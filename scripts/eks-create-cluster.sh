#!/bin/bash

# Create EKS Kubernetes cluster using eksctl tool

# First, just a dry run
# eksctl create cluster \
#   --config-file=eks-config.yaml \
#   --dry-run > dryrun-eks.yaml

# Option 1: Create a cluster providing values in a config file
eksctl create cluster \
  --config-file=eks-config.yaml \
  --kubeconfig="~/.kube/eks.yaml"

# Option 2: Create a cluster providing values in a command line

# eksctl create cluster \
#   --name ekscluster \
#   --version 1.25 \
#   --region us-west-1 \
#   --nodegroup-name linux-nodes \
#   --node-type t3a.xlarge \
#   --nodes 2 \
#   --ssh-access \
#   --ssh-public-key ~/.ssh/id_ed25519_aws_hcl_petrkunc.pub \
#   --managed \
#   --kubeconfig=~/.kube/eks.yaml