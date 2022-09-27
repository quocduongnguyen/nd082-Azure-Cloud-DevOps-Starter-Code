variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "duongnq9-project1-devops"
  # Our resources group name will be: duongnq9-project1-devops-rg
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
  description = "Number of virtual machines, number of virtual machines should be at least 2, and no more than 5. If it is outside this range, it will is 2."
  default = 3
}