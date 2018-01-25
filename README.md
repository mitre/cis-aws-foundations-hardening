# cis-aws-foundations-hardening - v1.0.0

A terraform  hardening baseline the CIS AWS Foundations Benchmark v1.10.

## Overview

This will help you setup and validate an AWS VPC/ENV ...

## Usage

### Setup your Environment  

You will need to set the following env_vars for this to work.

- AWS_SUBNET_ID - The AWS Subnet you wish to use ... (default: none)
- AWS_SSH_KEY_ID - The SSH Key that is associated with ... (default: none)
- AWS_ACCESS_KEY_ID - The AWS Access Key that is ... (default: none)
- AWS_SECRET_ACCESS_KEY ... (default: none)
- AWS_DEFAULT_INSTANCE_TYPE ... (default: none) (suggested: t2.micro)
- AWS_REGION - The AWS Region you would like to use (default: us-east-1)
- AWS_AMI_ID ... (default: none)
- AWS_SG_ID ... (default: none)  


1. Switch to your Terraform 0.10.0 environment  
2. Ensure your environment variables are configured (see above)  
3. Run Bundle Command
- ```bundle exec rake test:aws:setup:cis```
- ```bundle exec rake test:aws:run:cis```
- ```bundle exec rake test:aws:cleanup:cis```


## Quetions:

- see: https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html
- see: https://github.com/chef/inspec-aws

## Developing

## Contributing

## Pushing a Pull Request