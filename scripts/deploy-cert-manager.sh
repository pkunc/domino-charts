#!/bin/bash

# Add jeststack repository to Helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm repo list

# Define new CRDs for cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml

# Deploy cert-manager to a dedicated namespace "cert-manager"
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.11.0