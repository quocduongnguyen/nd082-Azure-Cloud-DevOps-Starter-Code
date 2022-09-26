variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "duongnq9-project1-devops"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "centralus"
}

variable "username" {
  description = "Enter Username"
  default = "duongnq9"
}

variable "password" {
  description = "Enter Password"
  default = "Fsoft@12345678"
}

variable "NumberOfVM" {
  description = "Number of virtual machines"
  default = 3
}