#!/bin/bash

# Use the script when you want to upload files from your local system to a pod.
# Typical use case: upload existing *.nsf databases to a newly created Domino container.

# The script has no command line paramters
# You configure it by entering the values directly into the script file.

#------------

# Modify these values to match your environment
SERVER=alpha
LOCAL_DATA=../examples/data

# Automaticaly configured values
POD=$SERVER-domino-0
ARCHIVE=$POD.tgz

#------------

# Values for colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'        # No Color

#------------

# Print the input values

echo -e "[ℹ]  Copying local files to a Domino pod in Kubernetes"
echo -e "[ℹ]  Pod name:          ${YELLOW}$POD${NC}"
echo -e "[ℹ]  Local data path:   ${YELLOW}$LOCAL_DATA${NC}"

echo -e "[ℹ]  Content of the source directory:"
ls $LOCAL_DATA

#------------

# Confirm the correct data folder

QUESTION="${BLUE}Do you want to upload these files to the pod? (y/n) ${NC}"

read -p "$(echo -e $QUESTION)" yn

case $yn in 
	[yY] ) echo -e "[ℹ]  Packing local data into a tgz file: ${YELLOW}$ARCHIVE${NC}";;
	[nN] ) echo -e "[ℹ]  Exiting...";
		exit;;
	* ) echo Invalid response;
		exit 1;;
esac

#------------

# Pack and upload the data

cd $LOCAL_DATA

# tar -cvz --no-xattrs --disable-copyfile --exclude '.*'  -f ../$ARCHIVE .
tar -cvz --no-xattrs --disable-copyfile  -f ../$ARCHIVE .

echo -e "[ℹ]  Uploading tgz file into the pod..."
kubectl cp ../$ARCHIVE $POD:/local -c domino -n domino

echo -e "[ℹ]  Extacting tgz file in the pod..."
kubectl exec $POD -c domino -n domino -- tar -xvzf /local/$ARCHIVE --one-top-level=/local/upload_data
echo -e "[ℹ]  Deleting uploaded tgz file in the pod..."
kubectl exec $POD -c domino -n domino -- rm /local/$ARCHIVE

echo -e "[ℹ]  Deleting local tgz file..."
rm ../$ARCHIVE

echo -e "${GREEN}[✔]  Files uploaded to the pod and extracted to the folder: ${YELLOW}/local/upload_data${NC}"

echo -e "[ℹ]  Check the result - List of the files in the pod:"
kubectl exec $POD -c domino -n domino -- ls /local/upload_data