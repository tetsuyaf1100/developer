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
TOKEN=https://identity.gls.cloud.global.fujitsu.com
IDENTITY=$TOKEN
CONTRACT=https://contract.gls.cloud.global.fujitsu.com
BILL=https://billing.gls.cloud.global.fujitsu.com
DNS=https://dns.gls.cloud.global.fujitsu.com
CATALOG=https://catalog.gls.cloud.global.fujitsu.com

# Initial setup
NAME_FORMAT="TES_$(date "+%m%d")_$(who am I | cut -d " " -f1)_"

# Other
alias curl='curl --tlsv1.2'
SCRIPT_PATH=`pwd`
RES_DIR=response
RES_PATH=$SCRIPT_PATH/$RES_DIR
