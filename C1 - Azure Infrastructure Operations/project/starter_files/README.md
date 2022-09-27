# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Open file policyRules.json to write polic rules
2. Login Azure command line interface: az login
    (Azure command line interface needs to open on "..\nd082-Azure-Cloud-DevOps-Starter-Code\C1 - Azure Infrastructure Operations\project\starter_files" folder)
3. Run script in CLI to create policy: az policy definition create --name tagging-policy --display-name "Require a tag on resources" --description "This policy audits if a resource without tag" --params "{ \"tagName\": { \"type\": \"String\", \"metadata\": { \"displayName\": \"Tag Name\", \"description\": \"Name of the tag, such as 'requiretag'\" } } }"  --mode Indexed --rules policyRules.json
4. Run script in CLI to apply policy: az policy assignment create --policy tagging-policy --params "{ \"tagName\": { \"value\": \"requiretag\" } }"
5. Run script in CLI to view policy applied list: az policy assignment list
6. Run script in CLI to create a resource group: az group create --name duongnq9-project1-devops-rg --location centralus
    (You can change "duongnq9-project1-devops" as the resource group name you want.
    You can change "centralus" as the location you want.)
7. Open server.json file to write image information
    7.1 Run "az account show --query "{ subscription_id: id }"" script in CLI to show subscription_id
    7.2 Run script in CLI to create app registration and show client_id, client_secret, tenant_id: az ad sp create-for-rbac --role Contributor --name sp-packer --scopes /subscriptions/{subscription_id}/resourceGroups/ResourceGroupName --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
        (Remember update subscription_id and of this script)
    7.3 
    image.png
9. Update client_id, client_secret, tenant_id in file server.json and run script in CLI to create image: packer build server.json
10. Create main.tf file contains resource information and variables.tf file contains variable. Update default values to changes values in variables.tf file, number of virtual machines should be at least 2, and no more than 5. Remember add requiretag tag to resource.
11. Add resource as project requirement.
12. Run script in CLI: terraform init, terraform plan -out solution.plan, terraform plan, terraform apply
13. Run script in CLI to delete generated resources: terraform destroy
### Output
policyRules.json file
server.json file
main.tf file
variables.tf
solution.plan file
Generated resources as project requirement in Azure

