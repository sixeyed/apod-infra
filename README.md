
See https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal

Create SP for `az` commands:

```
az ad sp create-for-rbac `
 --name 'apod-infra-sp' `
 --sdk-auth 
```

> Add output as GitHub secret called `AZURE_CREDENTIALS`

Create SP for AKS cluster:

```
az ad sp create-for-rbac `
 --skip-assignment `
 --name 'apod-infra-aks-sp'
```

> Create secret `AKS_SP_APP_ID` with `appId` value
> Create secret `AKS_SP_APP_PASSWORD` with `password` value
