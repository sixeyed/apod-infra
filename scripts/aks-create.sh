#!/bin/bash

# create RG if needed:
az group show --name $RG_NAME > /dev/null
if [ $? != 0 ]; then
	echo "Creating new resource group: $RG_NAME"
	az group create --name $RG_NAME --location eastus > /dev/null
else
	echo "Using existing resource group: $$RG_NAME"
fi

# create cluster if not exists:
az aks show --resource-group $RG_NAME --name $AKS_NAME > /dev/null
if [ $? != 0 ]; then
    echo "Creating AKS cluster: $AKS_NAME"
    az aks create -g $RG_NAME -n $AKS_NAME \
    --node-count 2 --kubernetes-version 1.18.10 \
    --service-principal $AKS_SP_APP_ID \
    --client-secret $AKS_SP_APP_PASSWORD \
    --generate-ssh-keys
else
	echo "Cluster: $AKS_NAME already exists, no changes made - resource group: $RG_NAME"
fi