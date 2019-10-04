provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_instance" "example" {
  ami           = "ami-048d25c1bda4feda7" # Ubuntu 18.04.3 Bionic, custom
  instance_type = "t2.micro"

  # new provisioner 
  provisioner "local-exec" {
      command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }  
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}
