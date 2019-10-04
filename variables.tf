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
