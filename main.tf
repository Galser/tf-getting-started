provider "aws" {
  profile    = "default"
  region     = "${var.region}"
}

module "nginxweb" {
  source                = "./nginxweb"

  ami                   = var.amis[var.region]
  instance_type         = "t2.micro"
  subnet_id             = var.subnet_ids[var.region]
  vpc_security_group_id = var.vpc_security_group_ids[var.region]

  learntag = "${var.learntag}"
  
}

output "public_ip" {
  value = "${module.nginxweb.public_ip}"
}

output "public_dns" {
  value = "${module.nginxweb.public_dns}"
}
