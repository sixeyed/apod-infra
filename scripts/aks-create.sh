#!/bin/bash

az group create --name $RG_NAME --location eastus

az aks create -g $RG_NAME -n $AKS_NAME \
  --node-count 2 --kubernetes-version 1.18.10 \
  --service-principal $AKS_SP_APP_ID \
  --client-secret $AKS_SP_APP_PASSWORD \
  --generate-ssh-keys
