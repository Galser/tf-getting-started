provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_instance" "example" {
  ami           = "ami-048d25c1bda4feda7" # Ubuntu 18.04.3 Bionic, custom
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}

# INtentionally commented to demo the facvt of removal 
#resource "aws_instance" "another" {
#  ami           = "ami-08a162fe1419adb2a"
#  instance_type = "t2.micro"
#}

