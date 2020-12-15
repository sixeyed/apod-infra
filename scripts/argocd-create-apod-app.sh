#!/bin/bash

kubectl create ns apod

argocd app create apod \
 --repo https://github.com/sixeyed/apod-app.git \
 --path kustomize/base \
 --dest-server https://kubernetes.default.svc \
 --dest-namespace apod \
 --sync-policy automated