#!/bin/bash

az aks get-credentials -g $RG_NAME -n $AKS_NAME

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$ARGOCD_VERSION/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

PWD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}')
argocd login localhost --insecure --username admin --password $PWD
argocd cluster add $AKS_NAME

echo ''
echo '----------------'
echo "ArgoCD UI: $(kubectl get svc -n argocd argocd-server -o jsonpath='http://{.status.loadBalancer.ingress[0].*}')"
echo "ArgoCD Pod name: $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}')"
echo '----------------'