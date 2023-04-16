#!/bin/bash

# Authenticate with the Azure CLI
# az login

# Delete Kubernetes cluster
az aks delete --name mycluster 

# Delete vnet used by the cluster
az network vnet delete --name aks-vnet --resource-group aks
az network vnet list