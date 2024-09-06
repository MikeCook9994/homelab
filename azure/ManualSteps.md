## Manual Steps

1. Create the resource group(s) that resources are to be deployed into.
2. Create the managed identity that will be used by github actions to orchestrate the deployment of arm resources
3. Give this managed identity "Contributor" and "Role Based Access Control Administrator" roles on the subscription
4. Set up federated credentials on the managed identity for the workflow
5. Update the workflow with the managed identity's client id and the name of the resource groups

## Documentation

* https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=CLI%2Copenid
  * Discusses the steps necessary to configure a github actions to be able to create ARM resources