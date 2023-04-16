#!/bin/bash

# Add ingress-nginx repository to Helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm repo list

# Deploy ingress-nginx to a dedicated namespace "ingress-nginx"
helm install \
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz