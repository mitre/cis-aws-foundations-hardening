# cis-aws-foundations-hardening - v1.0.0

A terraform / kitchen-terraform hardening baseline the CIS AWS Foundations Benchmark v1.10.

## Overview

This will help you setup and validate an AWS Environment as per CIS AWS Benchmark. This build will not modify existing resources.
It will modify default `default vpc` and each `default security group` as per CIS guidance.


### Tech Used
- kitchen-terraform (v3.0.0)
- test-kitchen (v.1.60.0)
- inspec.io
- terraform ( > v0.10.2)
- tfenv
- awscli (v1.1)

## Pre-Checks

A. Use `tfenv` to switch to your `tf v0.11.0` environment  
B. Install any needed gems via `bundle install`  
C. Use the `pre-kitchen.rb` script to ensure you have all the env_vars setup as needed.  
```
ruby pre-kitchen.rb
```
D. Go to the 'Usage' section  

## Usage

### Setup your Environment  

Please see TESTING_AGAINST_AWS.md for details on how to setup the needed AWS accounts to perform testing.

You will need to set the following env_vars for this to work.

- AWS_ACCESS_KEY_ID - The AWS Access Key that is ... (default: none)
- AWS_SECRET_ACCESS_KEY ... (default: none)
- AWS_REGION - The AWS Region you would like to use (default: us-east-1)

### Provide Infrastructure Data 

Provide data for the infrastructure build in the file:
/test/integration/cis/build/terraform.tfvars

```
- instance_type= "t2.micro"
- instance_key_name= "aws_key_name"
- ssh_security_group_cidr= "108.30.0.0/32"
```

### Build/Verify

Run Test kitchen

  a. `bundle exec kitchen list`  
  b. `bundle exec kitchen create cis-setup`  
  c. `bundle exec kitchen converge cis-setup`  
  d. `bundle exec kitchen verify cis-setup`  
  e. `bundle exec kitchen destroy cis-setup`  


### Known Issues

1) AWS Simple Queue Service takes a few minutes to build, so please wait a few minutes before running `kitchen verify`.

2) Known Terrafrom bug that affects Managed policy attachment shows up on a second `kitchen converge` or `kitchen destroy`. 
https://github.com/hashicorp/terraform/issues/5979 .
Please converge or destroy again to get past the error.

## Questions:

- see: https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html
- see: https://github.com/chef/inspec-aws

## Developing

## Contributing

## Pushing a Pull Request
