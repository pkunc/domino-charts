#!/bin/bash

# Get paramteres from the command line
if [ $# -lt 2 ];
then
  echo "[!]  $0: Missing arguments. Two parameters required:"
  echo -e "[ℹ]     server name \n[ℹ]     cluster provider"
  echo "[ℹ]  Example: $0 castor lke"
  exit 1
elif [ $# -gt 2 ];
then
  echo "[!]  $0: Too many arguments. Use just two parameters:"
  echo -e "[ℹ]     server name \n[ℹ]     cluster provider"
  echo "[ℹ]  Example: $0 castor lke"
  exit 1
else
  SERVER=$1 PROVIDER=$2
fi

#------------

echo "[ℹ]  Deploying Domino server '$SERVER' on Kubernetes cluster provider '$PROVIDER'"

# Deploy a Domino server using a Helm chart with necessary parameters
helm upgrade $SERVER ./charts/domino --install \
  --namespace domino \
  --create-namespace \
  --values examples/$SERVER-$PROVIDER.yaml \
  --set-file files.certID=examples/ids/cert.id \
  --set-file files.serverID=examples/ids/server-$SERVER.id \
  --set-file files.adminID=examples/ids/admin.id