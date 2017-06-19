#!/bin/bash

# Copyright FUJITSU LIMITED 2015-2017

# Account information
DOMAIN_NAME=$YOUR_DOMAIN_NAME
DOMAIN_ID=$YOUR_DOMAIN_ID
TENANT_ID=$YOUR_TENANT_ID
PROJECT_ID=$TENANT_ID
REGION=$YOUR_REGION
USER_NAME=$YOUR_USER_NAME
USER_PW=$YOUR_USER_PW

# Endpoints shortcut
echo "Endpoints initial setup"
TOKEN=https://identity.$REGION.cloud.global.fujitsu.com
IDENTITY=$TOKEN
NETWORK=https://networking.$REGION.cloud.global.fujitsu.com
COMPUTE=https://compute.$REGION.cloud.global.fujitsu.com
CEILOMETER=https://telemetry.$REGION.cloud.global.fujitsu.com
TELEMETRY=$CEILOMETER
DB=https://database.$REGION.cloud.global.fujitsu.com
BLOCKSTORAGE=https://blockstorage.$REGION.cloud.global.fujitsu.com
HOST_BLOCKSTORAGEV2=$BLOCKSTORAGE
OBJECTSTORAGE=https://objectstorage.$REGION.cloud.global.fujitsu.com
ORCHESTRATION=https://orchestration.$REGION.cloud.global.fujitsu.com
ELB=https://loadbalancing.$REGION.cloud.global.fujitsu.com
AUTOSCALE=https://autoscale.$REGION.cloud.global.fujitsu.com
IMAGE=https://image.$REGION.cloud.global.fujitsu.com
MAILSERVICE=https://mail.$REGION.cloud.global.fujitsu.com
NETWORK_EX=https://networking-ex.$REGION.cloud.global.fujitsu.com
DNS=https://dns.cloud.global.fujitsu.com
COMPUTE_SAP=https://compute-w.$REGION.cloud.global.fujitsu.com
KEYMANAGEMENT=https://keymanagement.$REGION.cloud.global.fujitsu.com
SOFTWARE=https://software.$REGION.cloud.global.fujitsu.com
VMIMPORT=https://vmimport.$REGION.cloud.global.fujitsu.com
VMEXPORT=https://import-export.$REGION.cloud.global.fujitsu.com

# Initial setup
NAME_FORMAT="TES_$(date "+%m%d")_$(who am I | cut -d " " -f1)_"

# Other
alias curl='curl --tlsv1.2'
SCRIPT_PATH=`pwd`
RES_DIR=response
RES_PATH=$SCRIPT_PATH/$RES_DIR
