#!/bin/bash

# Add jeststack repository to Helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm repo list

# Deploy cert-manager to a dedicated namespace "cert-manager"
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.11.0 \
  --set installCRDs=true