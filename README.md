# cis-aws-foundations-hardening - v1.0.0

A terraform / kitchen-terraform hardening baseline the CIS AWS Foundations Benchmark v1.10.

## Overview

This will help you setup and validate an AWS VPC/ENV ...

### Tech Used
- kitchen-terraform (v3.0.0)
- test-kitchen (v.1.60.0)
- inspec.io
- terraform (v0.10.0)
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

You will need to set the following env_vars for this to work.

- AWS_ACCESS_KEY_ID - The AWS Access Key that is ... (default: none)
- AWS_SECRET_ACCESS_KEY ... (default: none)
- AWS_REGION - The AWS Region you would like to use (default: us-east-1)


1. Switch to your Terraform 0.11.0 environment  
2. Ensure your environment variables are configured (see above)  
3. Run Test kitchen

  **A.** **Run Each Phase of the Test Suite**  
  a. `bundle exec kitchen create`  
  b. `bundle exec kitchen converge`  
  c. `bundle exec kitchen verify`  
  d. `bundle exec kitchen destroy`  
  **B.** **Run the Fully Automated Suite**   
  a. `bundle exec kitchen test --destroy=always`

## Quetions:

- see: https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html
- see: https://github.com/chef/inspec-aws

## Developing

## Contributing

## Pushing a Pull Request
