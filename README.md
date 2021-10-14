# terraform-scripts
# How to use
1. Download Terraform.exe from internet and change "path" environment variable of your system to point to this exe
2. Clone the repo
3. Navigate to the repo and run "terraform init" to install azurerm plugin
4. Add a file "terraform.tfvars" and provide values for all variables defined under "variables.tf"
5. Run "terrafrom plan" to check what will be changed on applying the script.
6. This script ensures existence of following resources (more resources can be addd in the future):
  - 1 resource group
  - 1 vnet
  - 1 subnet
  - 1 nsg
  - 1 3 nsg rules to allow traffic on port 80, 3389, 300
  - 1 nic
  - 1 vm (without public ip)
7. Once you are satisfied with the changes that will done you can apply them with command "trerraform apply". To avod validation, run "trerraform apply --auto-approv"
