#!/bin/bash

SERVER=lupus
POD=$SERVER-domino-0
LOCAL_DATA=examples/data
ARCHIVE=$POD.tgz

echo "[ℹ]  Copying local files to a Domino pod in Kubernetes"
echo "[ℹ]  Pod name:          $POD"
echo "[ℹ]  Local data path:   $LOCAL_DATA"

echo "[ℹ]  Packing local data into a tgz file: $ARCHIVE"
cd $LOCAL_DATA
# tar -cvz --no-xattrs --disable-copyfile --exclude '.*'  -f ../$ARCHIVE .
tar -cvz --no-xattrs --disable-copyfile  -f ../$ARCHIVE .

echo "[ℹ]  Uploading tgz file into a pod..."
kubectl cp ../$ARCHIVE $POD:/local -n domino

echo "[ℹ]  Extacting tgz file on a pod..."
kubectl exec $POD -n domino -- tar -xvzf /local/$ARCHIVE --one-top-level=/local/upload_data
echo "[ℹ]  Deleting uploaded tgz file..."
kubectl exec $POD -n domino -- rm /local/$ARCHIVE

echo "[ℹ]  Deleting local tgz file..."
rm ../$ARCHIVE

echo "[✔]  Files uploaded to the pod and extracted to a folder: /local/upload_data"