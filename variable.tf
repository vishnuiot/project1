variable "instance_type" {
  description = "Instance type"
  type        = string
  #default     = "t3a.micro"
}

variable "iam_user" {
  type        = string
  description = "IAM_user"

}

variable "access_key" {
  type        = string
  description = "access_key"
  #default = ""
}

variable "secret_key" {
  type        = string
  description = "secret_key"
  #default = ""
}

variable "region" {
  type        = string
  description = "region"
  #default = "ap-south-1"
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
  #default = "ap-south-1a"
}

variable "ami" {
  type        = string
  description = "ami"
#default = "ami-0f5ee92e2d63afc18"
}

# variable "environment_name" {
#   type        = string
#   description = "environment_name"
# }