variable "aws_region" {
    default = "us-east-1"
}

variable "aws_access_key" {
    default = "access_key"
}

variable "aws_secret_key" {
    default = "secret_key"
}

variable "ami" {
    type = map(string)
    default = {
        us-east-1 = "ami-0d204b1f624e3b51d"
        us-east-2 = "ami-0ceb72675fda9532a"
    }
}

variable "ec2_user" {
    default = "ec2-user"
}

variable "public_key_path" {
    default = "./keys/prod-key-pair.pub"
}

variable "private_key_path" {
    default = "./keys/prod-key-pair"
}
