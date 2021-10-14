variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "resource_location" {}
variable "project_name"  {}
variable "vm_size" {}
variable "vm_image_uri" {}
variable "virtual_network_address_space" {}
variable "subnet_address_prefix" {}
variable "ip" {}
variable "vm_admin_user" {}
variable "vm_admin_pass" {}
locals {
    resource_groupe_name        = var.project_name
    resource_prefix             = var.project_name
    server_name                 = "${var.project_name}-vm"
}
