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
8. Run "az account show --query "{ subscription_id: id }"" script in CLI to show subscription_id
9. Run script in CLI to create app registration and show client_id, client_secret, tenant_id: az ad sp create-for-rbac --role Contributor --name sp-packer --scopes /subscriptions/{subscription_id}/resourceGroups/ResourceGroupName --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
        (Remember update subscription_id and of this script)
10. Update the subscription_id, client_id, client_secret, tenant_id values in the variables section of the server.json file and save it.

# Using Packer to build image from server.json file:
11. Run script "packer build server.json" in CLI. Image name is value of "managed_image_name" in server.json. Image will be created in the resource group created in step 6.
#

12. Open main.tf file: This is main configuration file where we are going to define our resource definition. You can add the resources you want to create here. Remember add requiretag tag to resource.
13. Openvariables.tf file: This is the file where we are going to define our variables. You can change the values of the variables if you want by changing the value of default. The values of the two variables prefix and centralus will be used for most resources and should be the same as the resource group information you created in step 6.

# Using Terraform to create resources in the resource group created in step 6.
14. Run script "terraform init" in CLI to init. This command performs several different initialization steps in order to prepare the current working directory for use with Terraform.

15. Run script "terraform plan" in CLI to init. This command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

16. Run script "terraform apply" in CLI to init. This command executes the actions proposed in a Terraform plan.

17. Run script "terraform destroy" in CLI to delete generated resources.

### Output
policyRules.json file
server.json file
main.tf file
variables.tf
solution.plan file
Generated resources as project requirement in Azure

