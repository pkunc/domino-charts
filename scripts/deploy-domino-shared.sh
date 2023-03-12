#!/bin/bash

# Change this paramter to point to the file with values for your environment
VALUES_FILE=examples/domino-shared-academy.yaml

# Deploy shared Domino elements using a Helm chart with necessary parameters
helm upgrade domino-shared ./charts/domino-shared --install \
  --namespace domino \
  --create-namespace \
  --values $VALUES_FILE \
  --atomic