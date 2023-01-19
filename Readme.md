# Terraform Interview

## Software used

### Terraform 
```bash
terraform --version

Terraform v1.3.4
on darwin_amd64
+ provider registry.terraform.io/hashicorp/aws v4.50.0
+ provider registry.terraform.io/hashicorp/local v2.3.0
+ provider registry.terraform.io/hashicorp/null v3.2.1
+ provider registry.terraform.io/hashicorp/tls v4.0.4

Your version of Terraform is out of date! The latest version
is 1.3.7. You can update by downloading from https://www.terraform.io/downloads.html
```

### AWS CLI

```bash
aws --version                                                                                                                          17:16:57

aws-cli/2.8.10 Python/3.9.11 Darwin/21.6.0 exe/x86_64 prompt/off
```

## Steps to deploy

1. Add `terraform.tfvars` file to the root of the project. 
2. Populate the above file with the following, replacing values in `[]` for appropriate alternative:
```tfvars
aws_access_key = "[YOUR AWS ACCESS KEY]"
aws_secret_key = "[YOUR AWS SECRET KEY]"
```
3. run `terraform init` to set up the environment.
4. run `terraform validate` to ensure everything is working correctly.
5. To ensure safe deployment I suggest running `terraform plan -out [PLAN_PATH]` followed by `terraform apply -auto-approve [PLAN_PATH]`
   1. If you prefer to instant deploy you can just run `terraform apply -auto-approve`
   2. Additionally, if you would like to verify what is being created before deployment, remove the `-auto-approve` flag.
6. Once `terraform apply` has completed an IP will be output to the terminal. If you past this IP in a web browser, the basic website will show.

## More Explanations

First of all, I have created an isolated approach. I have seem many mamouth Terraform files but I find they are unmaintainable and hard to navigate. Keeping all the code in seperate files I can manage them as individual silo's. 

### Variables

I created the `variables.tf` and the `terraform.tfvars` files to allow this code to be shared without personal details leaking out, or requiring manual input every time you make a change to the terraform state. This keeps the code more secure. As you can see from my `.gitignore` file I have prevented any sensitive information from leaving my personal computer.

### SSH Keys

Defined in: ssh_keys.tf

As this is a custom shared environment, I wanted custom ssh keys generated on creation on the environment, this way there are no ssh keys ending up on github or via email. Keeping the custom aws environment, and my personal devices secure.

### Security Groups

Defined in: security_groups.tf

As you can see I have configured the security groups to allow inbound traffic for http and ssh from any ip. While this is desired for the HTTP protocol, it is over exposed for SSH. However, as myself and the company do not share access to a VPN with a static IP, I am unable to limit the IP addresses which can create SSH requests. To improve security I would add IP access limiting to prevent random ssh access attempts. Preferably using a VPN IP as previously mentioned so remote access for team members is still possible. Additionally, I have allowed outbound `https` as this protocol allows us to communicate with CloudFront.

### CloudFront

Defined in: cloudfront.tf

This is honestly my first time utilising CloudFront. It has been great to learn more about the technology.

### S3 Bucket

Defined in: s3_bucket.tf

### EC2 Webserver

Defined in: ec2_server.tf

This is the main device and the glue that brings the project together. This is where the webserver is hosted. I have disabled ebs delete on termination to ensure that if we decide to upgrade our EC2 instance to a larger space, this can be done with both the image server and the server code persisting beyond the device state change. This keeps our infastructure extensible and cyloed so if one item went down, the others still exist. While the website would not be accessible without an ec2 server. If the server hits a broken state we can re-run `terraform apply` to reinstate the upto date server.