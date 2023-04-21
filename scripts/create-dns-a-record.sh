#!/bin/bash

#------------

# Values for colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD="\033[1m"
NC='\033[0m'        # No Color

#------------

# Set generated hostname suffixes
HTTP_SUFFIX=""
NOMAD_SUFFIX="-nomad"

NRPC_SUFFIX="-notes"

export AWS_CLI_AUTO_PROMPT=off

#------------

if [ $# -ne 3 ];
then
  echo -e "[!]  $0: Incorrect number of arguments. Required parameters (in this order):
        - ${PURPLE}server_name${NC} (only the server part, not the full hostname)
        - ${BLUE}service${NC} (options: http, nomad, nrpc)
        - ${CYAN}expose_type${NC} (options: ingress, lb)"
  echo -e "[ℹ]  Examples:  $0 ${PURPLE}alpha${NC} ${BLUE}http${NC} ${CYAN}ingress${NC}
                $0 ${PURPLE}alpha${NC} ${BLUE}nomad${NC} ${CYAN}ingress${NC}
                $0 ${PURPLE}alpha${NC} ${BLUE}http${NC} ${CYAN}lb${NC}
                $0 ${PURPLE}alpha${NC} ${BLUE}nrpc${NC} ${CYAN}lb${NC}"
  exit 1
fi

SERVER=$1
SERVICE=$2
EXPOSE=$3

echo -e "[ℹ]  Creating A record for the server ${YELLOW}$SERVER${NC} and service ${YELLOW}$SERVICE${NC} using ${YELLOW}$EXPOSE${NC}."

#------------

# Get external hostname of Ingress Controller
INGRESS=`kubectl get --namespace domino ingress $SERVER-domino -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo "[ℹ]  Ingress Controller external hostname: $INGRESS"

# Get external hostname of Load Balancer
LB=`kubectl get --namespace domino service $SERVER-domino-ext -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo "[ℹ]  Load Balancer external hostname:      $LB"

# Get server hostname from Ingress Rule
HOSTNAME=`kubectl get --namespace domino ingress $SERVER-domino -o jsonpath='{.spec.rules[0].host}'`
echo "[ℹ]  Ingress rule hostname:                $HOSTNAME"

DOMAIN=${HOSTNAME#*.*}

#------------

# Calculate the desired new server hostname

case $SERVICE in

  http)
    FULL_HOSTNAME=$SERVER$HTTP_SUFFIX.$DOMAIN
    ;;

  nomad)
    FULL_HOSTNAME=$SERVER$NOMAD_SUFFIX.$DOMAIN
    ;;
  
  nrpc)
    FULL_HOSTNAME=$SERVER$NRPC_SUFFIX.$DOMAIN
    ;;
  
  *)
    echo -e "${RED}[!]  Incorrect service parameter: $SERVICE${NC}"
    echo "[ℹ]  Exiting without any change."
    exit 1
    ;;
esac


# Selet the value of the A record (to which hostname it should point)

case $EXPOSE in

  ingress)
    TARGET_HOSTNAME=$INGRESS
    ;;

  lb)
    TARGET_HOSTNAME=$LB
    ;;
   
  *)
    echo -e "${RED}[!]  Incorrect expose type parameter: $EXPOSE${NC}"
    echo "[ℹ]  Exiting without any change."
    exit 1
    ;;
esac



echo -e "[ℹ]  Desired state: ${YELLOW}(A) $FULL_HOSTNAME ---> $TARGET_HOSTNAME${NC}"

#------------

echo -e "\n[ℹ]  Updating DNS A record for $FULL_HOSTNAME in domain $DOMAIN"

ZONE_FULL_ID=`aws route53 list-hosted-zones-by-name --dns-name $DOMAIN --query "HostedZones[0].Id" --output text`
echo "[ℹ]  zone full id:" $ZONE_FULL_ID
ZONE_ID=${ZONE_FULL_ID#"/hostedzone/"}
echo "[ℹ]  zone id:     " $ZONE_ID

DNS_RESULT=`aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
  {
    "Comment": "Updating server hostname"
    ,"Changes": [{
      "Action"              : "UPSERT"
      ,"ResourceRecordSet"  : {
        "Name"              : "'"$FULL_HOSTNAME"'"
        ,"Type"             : "A"
        ,"TTL"              : 120
        ,"ResourceRecords"  : [{
            "Value"         : "'"$TARGET_HOSTNAME"'"
        }]
      }
    }]
  }
  ' \
  --query "ChangeInfo.Status" \
  --output text`

echo "[ℹ]  change result status:" $DNS_RESULT

#------------

echo -e "\n${GREEN}[✔]  The request to create A record was created.${NC}"
echo "[ℹ]  Checking new DNS record resolving for $FULL_HOSTNAME"
echo "[ℹ]  Ingress Controller external hostname:" $TARGET_HOSTNAME
echo "[ℹ]  DNS record A (dig):              " `dig +short $FULL_HOSTNAME`