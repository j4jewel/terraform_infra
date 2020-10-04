# terraform_infra
A simple infrastructure using terraform in AWS.

Creates a VPC with two public and private subnets.
Deploys two ec2 instances, One Bastion and One web server. Deploys an RDS instance for Database.
Creates an ALB and attach it to the web instance to expose the webapplication.


 ##### Execution
#
```sh
#terraform validate   - syntax check 

#terraform plan - Creating an execution plan ( to check what will get installed before running it)

# terraform apply - Applying

# terraform destroy - Destroying what we have applied through terrafrom apply

We can also use -auto-approve while applying.
# terraform apply -auto-approve

```
 
