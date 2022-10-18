variable "instance_type" {
  description = "Instance type"
  type        = string
  #default     = "t3a.micro"
}

variable "access_key" {
  type        = string
  description = "access_key"
  #default = "AKIAYVIIU5BYXAUQXEXD"
}

variable "secret_key" {
  type        = string
  description = "secret_key"
  #default = "/3iTkjRAs/cq68Hx13uJK6K31CKAxK1t2j3x2x8v"
}

variable "region" {
  type        = string
  description = "region"
  #default = "/3iTkjRAs/cq68Hx13uJK6K31CKAxK1t2j3x2x8v"
}

variable "tags" {
  type        = string
  description = "tags"
  #default = ""
}

variable "key_name" {
  type        = string
  description = "keyname"
  #default = ""
}
variable "availability_zone" {
  type        = string
  description = "availability zone"
  #default = ""
}

variable "ami" {
  type        = string
  description = "ami"

}

# variable "environment_name" {
#   type        = string
#   description = "environment_name"
# }