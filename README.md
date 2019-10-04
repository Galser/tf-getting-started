# tf-getting-started
Skills map - 200 Terraform, getting started from installing until remote

# Subgoals progress

> Note : All the steps have been executed and tested on macOS Mojave , version 10.14.6 (18G95)


### Install Terraform 
- Follow this guide https://learn.hashicorp.com/terraform/getting-started/install . 
- Test path settings and availability for execution with command:
  ```
  which terraform
  ```
  Output : 
  ```
  /usr/local/bin/terraform
  ```
- Test version by executing :
  ```
  terraform --version
  ```
  Output : 
  ```
  Terraform v0.12.9
  ```

### Build Infra
- Following this part : https://learn.hashicorp.com/terraform/getting-started/build
- Modification for my case : 
    - Region : `eu-central-1`
    - AMI : `ami-08a162fe1419adb2a`
- After typing and saving all the code, we still need to :
    - Arrange AWS auth credentials (You can create security credentials on [this page](https://console.aws.amazon.com/iam/home?#security_credential).) via env variables, execute in command line : 
    ```
    export AWS_ACCESS_KEY_ID="YOUR ACCESS KEY"
    export AWS_SECRET_ACCESS_KEY="YOUR SECRET KEY"
    ```
    - The first command to run for a new configuration -- or after checking out an existing configuration from version control -- is 
    ```
    terraform init
    ```
    which initializes various local settings and data that will be used by subsequent commands. Run it.
- Now you can test the configuration by executing : 
    ```
    terraform plan
    ```
    > Note -  in the latest version of the Terraform we can just go with apply immediately, see below 
- And apply code to create infrastructure by executing :
    ```
    terraform apply
    ```
    
    Output starts : 
    ```
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

        Terraform will perform the following actions:

        # aws_instance.example will be created
        + resource "aws_instance" "example" {
            + ami                          = "ami-08a162fe1419adb2a"
            + arn                          = (known after apply)
            + associate_public_ip_address  = (known after apply)
            + availability_zone            = (known after apply)
            + cpu_core_count               = (known after apply)
    ```
    we skip middle part...output ends with : 
    ```
    Plan: 1 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value:     
    ```
    Answer `yes` here and you should get : 
    ```
    aws_instance.example: Creating...
    aws_instance.example: Still creating... [10s elapsed]
    aws_instance.example: Still creating... [20s elapsed]
    aws_instance.example: Creation complete after 22s [id=i-018d5c68823d11250]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```
    Sure you resource ID *[id=i-018d5c68823d11250]* is going to be different, but.. one instance just had been created.
- Now, check the contents of your folder, and you going to see additional directories and some additional files created by Terraform. Namely *".terraform", "terraform.tfstate"* 
 Remember that we don't want to potentially have sensitive information in Git, as well, as we don't want to have Terraform State in it. So better to safeguard the issue by creating **.gitingore** file in the root of the repo with the following content :
    ```
    .terraform
    terraform.tfstate
    terraform.tfstate.backup
    ```
    Last line is going to be useful for future iterations


### Change Infra
- Following this part : https://learn.hashicorp.com/terraform/getting-started/change
- Modification for my case : 
    - Region : `eu-central-1`
    - AMI : `ami-048d25c1bda4feda7`
- Change code according to the tutorial
- To apply changes run :
    ```
    terraform apply
    ```
    Observe output start :
    ```
    aws_instance.example: Refreshing state... [id=i-018d5c68823d11250]

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # aws_instance.example must be replaced
    -/+ resource "aws_instance" "example" {
          ~ ami                          = "ami-08a162fe1419adb2a" -> "ami-048d25c1bda4feda7" # forces replacement
         ~ arn                          = "arn:aws:ec2:eu-central-1:729476260648:instance/i-018d5c68823d11250" -> (known after apply)
        ~ associate_public_ip_a
    ```
    > Note that prefix -/+ means that Terraform will destroy and recreate the resource, rather than updating it in-place. While some attributes can be updated in-place (which are shown with the ~ prefix), changing the AMI for an EC2 instance requires recreating it. Terraform handles these details for you, and the execution plan makes it clear what Terraform will do.
    
    Answer yes to the Terraform's question, and here is the possible output : 
    ```
    aws_instance.example: Destroying... [id=i-018d5c68823d11250]
    aws_instance.example: Still destroying... [id=i-018d5c68823d11250, 10s elapsed]
    aws_instance.example: Destruction complete after 20s
    aws_instance.example: Creating...
    aws_instance.example: Still creating... [10s elapsed]
    aws_instance.example: Still creating... [20s elapsed]
    aws_instance.example: Creation complete after 22s [id=i-0048a50ed241b6a2a]

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
    ```

    
### Destroy infra

- Follow this post : https://learn.hashicorp.com/terraform/getting-started/destroy 
- To process run : 
    ```
    terraform destroy
    ``` 
- My output : 
    ```
    aws_instance.example: Refreshing state... [id=i-0048a50ed241b6a2a]

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    - destroy

    Terraform will perform the following actions:

    # aws_instance.example will be destroyed
    - resource "aws_instance" "example" {
        - ami                          = "ami-048d25c1bda4feda7" -> null
        - arn                          = "arn:aws:ec2:eu-central-1:729476260648:instance/i-0048a50ed241b6a2a" -> null
        - associate_public_ip_address  = true -> null
        - availability_zone            = "eu-central-1c" -> null
    ```
    ...
    and after `yes` :
    ```
    aws_instance.example: Destroying... [id=i-0048a50ed241b6a2a]
    aws_instance.example: Still destroying... [id=i-0048a50ed241b6a2a, 10s elapsed]
    aws_instance.example: Still destroying... [id=i-0048a50ed241b6a2a, 20s elapsed]
    aws_instance.example: Destruction complete after 30s

    Destroy complete! Resources: 1 destroyed.
    ```
    
### Resource Dependencies

- According to the part : https://learn.hashicorp.com/terraform/getting-started/dependencies
- After adding proper code execute : 
    ```
    terraform apply
    ```
    Observe output start :
    ```
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # aws_eip.ip will be created
    + resource "aws_eip" "ip" {
        + allocation_id     = (known after apply)
    ```
    Terraform will create two resources: the instance and the elastic IP. In the "instance" value for the "aws_eip", you can see the raw interpolation is still present. This is because this variable won't be known until the "aws_instance" is created. It will be replaced at apply-time.
    Answer yes, and observe : 
    ```
    aws_instance.example: Creating...
    aws_instance.example: Still creating... [10s elapsed]
    aws_instance.example: Still creating... [20s elapsed]
    aws_instance.example: Creation complete after 22s [id=i-0ab28845c5b11e3f9]
    aws_eip.ip: Creating...
    aws_eip.ip: Creation complete after 1s [id=eipalloc-04900480435a3f37c]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    ```
    As shown above, Terraform created the EC2 instance before creating the Elastic IP address. Due to the interpolation expression that passes the ID of the EC2 instance to the Elastic IP address, Terraform is able to infer a dependency, and knows it must create the instance first.
- Now tune the configuration by adding another EC2 instance:
    ```terraform
    resource "aws_instance" "another" {
      ami           = "ami-08a162fe1419adb2a"
      instance_type = "t2.micro"
    }
    ```
- Run :
    ```
    terraform apply
    ```
    And confirm.
    New instance added : 
    ```
    aws_instance.another: Creating...
    aws_instance.another: Still creating... [10s elapsed]
    aws_instance.another: Still creating... [20s elapsed]
    aws_instance.another: Creation complete after 22s [id=i-0769313e8692105ae]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```
    Because this new instance does not depend on any other resource, it can be created in parallel with the other resources. Where possible, Terraform will perform operations concurrently to reduce the total time taken to apply changes.

- Before moving on, remove this new resource from your configuration and run `terraform apply` again to destroy it. 

### Provision

- Following this post : https://learn.hashicorp.com/terraform/getting-started/provision
- Modify code so the instance description looks like:
    ```terraform
    resource "aws_instance" "example" {
        ami           = "ami-048d25c1bda4feda7" # Ubuntu 18.04.3 Bionic, custom
        instance_type = "t2.micro"

        # new provisioner 
        provisioner "local-exec" {
            command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
        }  
    }
    ```
- Provisioners are only run when a resource is created. Make sure that your infrastructure is **destroyed** if it isn't already, then run **apply**:
    ```
    terraform apply
    ```
    Observe output  :
    ```
    ...
    aws_instance.example: Creating...
    aws_instance.example: Still creating... [10s elapsed]
    aws_instance.example: Still creating... [20s elapsed]
    aws_instance.example: Still creating... [30s elapsed]
    aws_instance.example: Provisioning with 'local-exec'...
    aws_instance.example (local-exec): Executing: ["/bin/sh" "-c" "echo 18.185.90.184 > ip_address.txt"]
    aws_instance.example: Creation complete after 33s [id=i-07be38b2d9f304a56]
    aws_eip.ip: Creating...
    aws_eip.ip: Creation complete after 1s [id=eipalloc-0897dd71fad317f86]
    ```
    You can clear see : **Provisioning with 'local-exec'...**
    Terraform will output anything from provisioners to the console, but in this case there is no direct output. However, we can verify everything worked by looking at the ip_address.txt file:
    ```shell
    $ cat ip_address.txt
    18.185.90.184
    ```
    > Note : Your IP address may differ

### Input Variables
- According to the :  https://learn.hashicorp.com/terraform/getting-started/variables
- Let's first extract our region into a variable. Create another file `variables.tf` with the following contents.
    ```terraform
    variable "region" {
      default = "eu-central-1"
    }
    ```
This defines the region variables within your Terraform configuration. There is a default value, but is optional. Otherwise, If no default is set, the variable is required.
> Note: that the file can be named anything, since Terraform loads all files ending in .tf in a directory. 

- Next, replace the AWS provider configuration with the following:
    ```terraform
    provider "aws" {
      region     = var.region
    }
    ```
    This uses more interpolations, this time prefixed with `var.` and it tells Terraform that you're accessing variables. This configures the AWS provider with the given variables.

- We've replaced our sensitive strings with variables, but we still are hard-coding AMIs. Unfortunately, AMIs are specific to the region that is in use. One option is to just ask the user to input the proper AMI for the region, but Terraform can do better than that with maps.

    Maps are a way to create variables that are lookup tables. An example will show this best. Let's extract our AMIs into a map and add support for the *us-east-2* region as well,
    add to `variables.tf` file : 
    ```terraform
    variable "amis" {
        type = "map"
        
        default = {
        "us-east-2"    = "ami-00f03cfdc90a7a4dd",
        "eu-central-1" = "ami-08a162fe1419adb2a"
        }
    } 
    ```
- Run apply to test it. 
    ```
    $ terraform apply
    ...
    -/+ resource "aws_instance" "example" {
      ~ ami                          = "ami-048d25c1bda4feda7" -> "ami-08a162fe1419adb2a" # forces replacement
    ...
    aws_instance.example: Provisioning with 'local-exec'...
    aws_instance.example (local-exec): Executing: ["/bin/sh" "-c" "echo 3.123.39.78 > ip_address.txt"]
    aws_instance.example: Creation complete after 32s [id=i-051b87b927fd30940]
    aws_eip.ip: Modifying... [id=eipalloc-0897dd71fad317f86]
    aws_eip.ip: Modifications complete after 1s [id=eipalloc-0897dd71fad317f86]
    ```
    As you can see from Terraform output above - the change in AMI forces replacement, e.g. now we using correct AMI for correct region from our defined map. 


### Output Variables

- According to the : https://learn.hashicorp.com/terraform/getting-started/outputs
- Let's define an output to show us the public IP address of the elastic IP address that we create. Adding this to `main.tf` file:
    ```terraform
    output "ip" {
      value = aws_eip.ip.public_ip
    }
    ```
- Run `terraform apply` to populate the output. This only needs to be done once after the output is defined. The apply output should change slightly. At the end you should see this:
    ```
    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    ip = 18.197.2.11
    ```
    apply **highlights** the outputs. You can also query the outputs after apply-time using `terraform output`: 
    ```
    $ terraform output ip
    18.197.2.11
    ```

### Modules

> Notes : Getting started on modules now https://learn.hashicorp.com/terraform/getting-started/modules can not be used right now in Terraform version 0.12
So I've created my own module to deploy set of web-servers with small Go program that drawing Lissajous figures

- We going to use custom module located in folder [nginxweb](nginxweb)

- Changing `main.tf`, removing all except provider definition at teh very beginning and add : 
    ```terraform
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
    ```
    This is reflecting usage of locally available module **nginxweb**
- Also adding some additional variables to the `variables.tf` to parametrize the code :
    ```terraform
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
    ```
- Before using `apply` for first time with above mentioned code we need to inform terraform about our module. Execute :
    ```
    terraform init
    ```
    Output :
    ```
    Initializing modules...
    - nginxweb in nginxweb
    ...
    ```
- Now let's apply our code changes : 
    ```
    terraform apply
    ```
    Output after some time :
    ```
    module.nginxweb.aws_instance.nginxweb[1]: Creation complete after 1m39s [id=i-0c52a4281a4505d15]

    Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

    Outputs:

    public_dns = [
    "ec2-18-195-23-15.eu-central-1.compute.amazonaws.com",
    "ec2-52-59-244-189.eu-central-1.compute.amazonaws.com",
    "ec2-3-120-251-230.eu-central-1.compute.amazonaws.com",
    ]
    public_ip = [
    "18.195.23.15",
    "52.59.244.189",
    "3.120.251.230",
    ]
    ```   
    So, the module had created and provisioned set of 3 servers running basic Nginx web server. Let's check that our servers indeed can server web pages. Checking with [cURL](https://curl.haxx.se/)  one of the IPs from outputs :
    ```html
     curl 18.195.23.15
        <!DOCTYPE html>
        <html>
        <head>
        <title>Welcome to nginx!</title>
        <style>
            body {
                width: 35em;
    ```
    All good, module performs as expected.
- As the last step run `destroy` to clean:
    ```
    terraform destroy
    ```
    Output:
    ```
    module.nginxweb.aws_instance.nginxweb[2]: Destruction complete after 30s
    module.nginxweb.aws_instance.nginxweb[0]: Destruction complete after 30s
    module.nginxweb.aws_instance.nginxweb[1]: Destruction complete after 30s
    module.nginxweb.aws_key_pair.tf200-aguselietov: Destroying... [id=aguselietov-key]
    module.nginxweb.aws_key_pair.tf200-aguselietov: Destruction complete after 1s

    Destroy complete! Resources: 4 destroyed.
    ```
That's conclude the "Getting Started"


# todo



# done

- [x] initial readme
- [x] - Installing Terraform
- [x] - Build Infrastructure
- [x] - Change Infrastructure
- [x] - Destroy Infrastructure
- [x] - Resource Dependencies
- [x] - Provision
- [x] - Input Variables
- [x] - Output Variables
- [x] - Modules
