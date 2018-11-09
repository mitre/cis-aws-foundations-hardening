# cis-aws-foundations-hardening - v1.0.0

A terraform / kitchen-terraform hardening baseline the CIS AWS Foundations Benchmark v1.10.

## Overview

This will help you setup and validate an AWS Environment as per CIS AWS Benchmark. This build will not modify existing resources.
It will modify default `default vpc` and each `default security group` as per CIS guidance.

## Versioning and State of Development
This project uses the [Semantic Versioning Policy](https://semver.org/). 

### Branches
The master branch contains the latest version of the software leading up to a new release. 

Other branches contain feature-specific updates. 

### Tags
Tags indicate official releases of the project.

Please note 0.x releases are works in progress (WIP) and may change at any time.   

### Tech Used
- kitchen-terraform (>=v3.0.0)
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

## Usage

### Setup your Environment  

Please see TESTING_AGAINST_AWS.md for details on how to setup the needed AWS accounts to perform testing.

Follow these instructions carefully.

1. Create an AWS account.  Make a note of the account email and root password in a secure secret storage system.
2. Create an IAM user named `test-fixture-maker`.
  * Enable programmatic access (to generate an access key)
  * Note the access key and secret key ID that are generated.
3. Create an IAM Group named `test-fixture-maker-group`.
  * Direct-attach the policy AdministratorAccess
  * Add user `test-fixture-maker` to the group

4. Set the required env variables.

- AWS Credentials
```
AWS_ACCESS_KEY_ID         - The AWS Access Key that is to be used (default: none)
AWS_SECRET_ACCESS_KEY     - The AWS Secret Access Key that is to be used (default: none)
```
- TF_VAR_ prevents credentials from being populated on terrafrom logs
```
TF_VAR_aws_ssh_key_id     - The value is the name of the AWS key pair you want to use (default: none) (hide from logs)
TF_VAR_aws_access_key     - The AWS Access Key that is to be used (default: none) (hide from logs)
TF_VAR_aws_secret_key     - The AWS Secret Access Key that is to be used (default: none) (hide from logs)
```
- Infrastructure Data
```
AWS_DEFAULT_REGION        - The AWS Region you would like to use (default: us-east-1)
AWS_DEFAULT_INSTANCE_TYPE - The EC2 instance type (also known as size) to use. (default: none)
SSH_SG_CIDR               - Specify an IP address in CIDR notation, a CIDR block for ssh ingress rule. (default: none)
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

## Questions

- see: https://newcontext-oss.github.io/kitchen-terraform/tutorials/amazon_provider_ec2.html
- see: https://github.com/chef/inspec-aws

## Developing

We use a feature-branch model for development. Plese create a fork and push a PR as a feature-branch.

## NOTICE 

© 2018 The MITRE Corporation.  

Approved for Public Release; Distribution Unlimited. Case Number 18-3678.    

## NOTICE  

This software was produced for the U. S. Government under Contract Number HHSM-500-2012-00008I, and is subject to Federal Acquisition Regulation Clause 52.227-14, Rights in Data-General.   

No other use other than that granted to the U. S. Government, or to those acting on behalf of the U. S. Government under that Clause is authorized without the express written permission of The MITRE Corporation.   

For further information, please contact The MITRE Corporation, Contracts Management Office, 7515 Colshire Drive, McLean, VA  22102-7539, (703) 983-6000.  

## NOTICE

CIS Benchmarks are published by the Center for Internet Security (CIS), see: https://www.cisecurity.org/.
