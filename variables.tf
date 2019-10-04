variable "region" {
  default = "eu-central-1"
}

variable "amis" {
  type = "map"
  default = {
    "us-east-2"    = "ami-00f03cfdc90a7a4dd",
    "eu-central-1" = "ami-08a162fe1419adb2a"
  }
}

# used later to delete all those instances
variable "learntag" {
  type    = "string"
  default = "200tf"
}

variable "subnet_ids" {
  type = "map"
  default = {
    "eu-central-1" = "subnet-7282ce1a"
  }
}

variable "vpc_security_group_ids" {
  type = "map"
  default = {
    "us-east-2"    = ""
    "eu-central-1" = "sg-04c059aea335d8f69"
  }
}

variable "instance_type" {
  default = "t2.micro"
}
