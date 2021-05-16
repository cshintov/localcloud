variable "region" {
  default     = "ap-south-1"
  type = string
  description = "AWS region"
}

variable "cluster_name" {
  type = string
  default = "tfone"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "project" {
  type = string
  default = "terraform"
}

variable "common_tags" {
    default = {
        "Managed By" = "Terraform"
    }
}
