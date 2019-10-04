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
    ```
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
    

# todo


- [ ] - Provision
- [ ] - Input Variables
- [ ] - Output Variables
- [ ] - Modules

# done

- [x] initial readme
- [x] - Installing Terraform
- [x] - Build Infrastructure
- [x] - Change Infrastructure
- [x] - Destroy Infrastructure
- [x] - Resource Dependencies
