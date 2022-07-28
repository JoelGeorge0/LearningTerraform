
variable "subscriptionID" {
  description = "holds subscription_id so you can make sure your deploying in the correct subscription"
}

variable "prefix" {
  description = "holds the begining of the naming scheme "
}

variable "Owner" {
  description = "holds the name of creator for tags"
}

variable "Enviorment" {
  description = "holds the current enviornment for tags"
}

variable "adminUserName" {
  description = "holds the admin username for the virtual machine"
}

variable "adminUserPassword" {
  description = "holds the admin user password for the virtual machine"
}