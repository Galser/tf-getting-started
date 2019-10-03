provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_instance" "example" {
  ami           = "ami-08a162fe1419adb2a" # Ubuntu 18.04.3 Bionic, EU
  instance_type = "t2.micro"
}