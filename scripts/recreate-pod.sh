#!/bin/bash

#------------

# Values for colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'        # No Color

# Check if one argument is passed

if [ $# -eq 0 ];
then
  echo -e "${RED}[!]  $0: Missing argument. Use server name as a parameter.${NC}"
  echo "[ℹ]  Example: $0 alpha"
  exit 1
elif [ $# -gt 1 ];
then
  echo -e "${RED}[!]$0: Too many arguments. Use just one parameter - a server name.${NC}"
  echo "[ℹ]  Example: $0 alpha"
  exit 1
else
  SERVER=$1
fi

#------------

# Check if the pod exists

POD=$SERVER-domino-0

echo -e "[ℹ]  Checking state for pod: ${YELLOW}$POD${NC}"

POD_STATE=$(kubectl get pod $POD -n domino --no-headers -o custom-columns=":status.phase" 2>&1)

if [[ "$POD_STATE" == *"NotFound"* ]]; then
  echo -e "${RED}[!]  Pod $POD does not exist!${NC}"
  echo "[ℹ]  Exiting..."
  exit 1
fi

# Check if the pod is in a Running state

echo "[ℹ]  Pod state is: $POD_STATE"

if [ $POD_STATE != Running ];
then
  echo "[ℹ]  The pod is not running. Exiting..."
  exit 0
fi

#------------

QUESTION="Do you want to recreate the pod $POD? (y/n) "

read -p "$QUESTION" yn


# Confirm the pod recreation

case $yn in 
	[yY] ) echo "[ℹ]  Recreating pod $POD";;
	[nN] ) echo "[ℹ]  Exiting...";
		exit;;
	* ) echo invalid response;
		exit 1;;
esac


# Recreate the pod

echo "[ℹ]  Deleting the current pod and creating a new one. Could take a few minutes...";
RECREATE_STATUS=$(kubectl get pod $POD -n domino -o yaml | kubectl replace --grace-period=120 --force --timeout=120s -f - 2>&1)
echo Result: $RECREATE_STATUS

echo -e "${GREEN}[✔]  The pod was successfully recreated.${NC}"