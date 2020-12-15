#!/bin/bash

az aks get-credentials -g $RG_NAME -n $AKS_NAME

echo "Deploying Argo CD version: $ARGOCD_VERSION"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$ARGOCD_VERSION/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl wait --for=condition=Ready pod -n argocd -l app.kubernetes.io/name=argocd-server

echo "Downloading Argo CD CLI version: $ARGOCD_VERSION"
sudo curl -sSL --create-dirs -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

echo "Configuring Argo CD with cluster: $AKS_NAME"
PWD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}')
HOST=$(kubectl get svc -n argocd argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].*}')
argocd login $HOST --insecure --username admin --password $PWD
argocd cluster add $AKS_NAME

echo ''
echo '----------------'
echo "ArgoCD UI: $(kubectl get svc -n argocd argocd-server -o jsonpath='http://{.status.loadBalancer.ingress[0].*}')"
echo "ArgoCD Pod name: $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}')"
echo '----------------'