# Configure VPC
variable "region_name" {
    description = "name of region"
    default = "eu-west-2"
    type = string
  
}

variable "cidr_for_vpc" {
    description = "the cidr for VPC"
    default = "10.0.0.0/16"
    type = string
  
}
# Configure Subnet
variable "cidr_for_prod_pub_sub_1" {
    description = "public cidr"
    default = "10.0.1.0/24"
    type = string
  
}

variable "cidr_for_prod_pub_sub_2" {
    description = "public cidr"
    default = "10.0.2.0/24"
    type = string
  
}

variable "cidr_for_prod_priv_sub_1" {
    description = "private cidr"
    default = "10.0.3.0/24"
    type = string
  
}

variable "cidr_for_prod_priv_sub_2" {
    description = "private cidr"
    default = "10.0.4.0/24"
    type = string

}