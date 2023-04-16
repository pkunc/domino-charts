#!/bin/bash

# Authenticate with the Azure CLI
az login

# Create Resource group "aks"
az group create --name aks --location germanywestcentral
az group list --output table

# Set Resource group "ask" as default
az config set defaults.group=aks
az config get

# Register providers with the subscription
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.Insights

az provider show -n Microsoft.OperationsManagement -o table
az provider show -n Microsoft.OperationalInsights -o table
az provider show -n Microsoft.Insights -o table

# Create a dedicated vnet for the cluster
az network vnet create \
  --name aks-vnet \
  --resource-group aks \
  --address-prefixes 192.168.0.0/16 \
  --subnet-name aks-subnet \
  --subnet-prefix 192.168.1.0/24
az network vnet list

# SUBNET_ID=$(az network vnet subnet show --resource-group aks --vnet-name aks-vnet --name aks-subnet --query id -o tsv)
# echo "Subnet ID:" $SUBNET_ID

# Create Azure AKS Kubernetes cluster
az aks create \
  --name mycluster \
  --resource-group aks \
  --location germanywestcentral \
  --enable-managed-identity \
  --nodepool-name default \
  --node-count 1 \
  --node-vm-size Standard_E4s_v3  \
  --node-osdisk-size 250 \
  --enable-addons monitoring \
  --enable-msi-auth-for-monitoring \
  --ssh-key-value "~/.ssh/id_rsa_azure.pub"

# Download kubeconfig file (with admin credentials)
az aks get-credentials --resource-group aks --name mycluster --admin -f ~/.kube/aks.yml