# tf-getting-started
Skills map - 200 Terraform, getting started from installing until remote

# Subgoals progress

> Note : All the steps been executed and tested on macOS Mojave , version 10.14.6 (18G95)


### Install Terraform 
- Follow this guide https://learn.hashicorp.com/terraform/getting-started/install . 
- Test path settings and availabilty for execution with command:
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
    - Arrange AWS auth credentials via env variables : 
    ```
    export AWS_ACCESS_KEY_ID="anaccesskey"
    export AWS_SECRET_ACCESS_KEY="asecretkey"
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
    > BUT - Note -  in the latest version of the Terraform we cna just go with apply immediately, see below 
- So, just apply code by executing :
    ```
    terraform apply
    ```
    
    Output start : 
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
    we skipp middle part ...
    Output ends with : 
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
- Now, check the contents of your folded, and you going to see additional directories and some additional files created by Terraform. Namely *".terraform", "terraform.tfstate"* 
 Remember that we don't want to potentially have sensitive information in Git, as well, as we don't want to have Terraform State in it. So better to safeguard the issue by creating **.gitingore** file in the root of the repo with the following content :
    ```
    .terraform
    terraform.tfstate
    terraform.tfstate.backup
    ```
    Last line is going to be useful for future iterations


# todo


- [ ] - Change Infrastructure
- [ ] - Destroy Infrastructure
- [ ] - Resource Dependencies
- [ ] - Provision
- [ ] - Input Variables
- [ ] - Output Variables
- [ ] - Modules

# done

- [x] initial readme
- [x] - Installing Terraform
- [x] - Build Infrastructure