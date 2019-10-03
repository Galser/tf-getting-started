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
    we skip middle part ...
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
- Change code
- To apply changes run :
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
    
    Answer yes to teh Terraform's question, and here is the possible output : 
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


# todo


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
- [x] - Change Infrastructure
