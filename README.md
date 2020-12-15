
```
az ad sp create-for-rbac `
 --name 'apod-infra-sp' `
 --sdk-auth 
```

> Add output as GitHub secret called `AZURE_CREDENTIALS`