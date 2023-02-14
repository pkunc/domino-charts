#!/bin/bash

export AWS_CLI_AUTO_PROMPT=off

#------------

if [ $# -eq 0 ];
then
  echo "$0: Missing argument. Use server name as a parameter."
  echo "Example: $0 alpha"
  exit 1
elif [ $# -gt 1 ];
then
  echo "$0: Too many arguments. Use just one parameter - a server name."
  echo "Example: $0 alpha"
  exit 1
else
  SERVER=$1
fi

#------------

# Get IP address of Ingress Controller
IP=`kubectl get --namespace domino ingress $SERVER-domino -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo 'Ingress Controller external IP: ' $IP

# Get hostname from Ingress Rule
HOSTNAME=`kubectl get --namespace domino ingress $SERVER-domino -o jsonpath='{.spec.rules[0].host}'`
echo 'Ingress rule hostname:          ' $HOSTNAME

DOMAIN=${HOSTNAME#*.*}

#------------

echo -e "\nUpdating DNS record for $HOSTNAME in domain $DOMAIN"

ZONE_FULL_ID=`aws route53 list-hosted-zones-by-name --dns-name $DOMAIN --query "HostedZones[].Id" --output text`
echo ... zone full id: $ZONE_FULL_ID
ZONE_ID=${ZONE_FULL_ID#"/hostedzone/"}
echo ... zone id: $ZONE_ID

DNS_RESULT=`aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
  {
    "Comment": "Updating server hostname"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'"$HOSTNAME"'"
        ,"Type"             : "A"
        ,"TTL"              : 120
        ,"ResourceRecords"  : [{
            "Value"         : "'"$IP"'"
        }]
      }
    }]
  }
  ' \
  --query "ChangeInfo.Status" \
  --output text`

echo ... change result status: $DNS_RESULT

#------------

echo -e "\nChecking new DNS record resolving for $HOSTNAME"
echo ... "instance IP:   " $IP
echo ... "DNS record IP: " `dig +short $HOSTNAME`