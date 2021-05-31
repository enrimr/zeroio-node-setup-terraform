> :warning: **This Terraform script runs over Google Cloud Platform (GCP). If you use it to deploy your ZERO validator node, it will incur into costs in your GCP billing account**. If you don't want to pay, you can use only the script create_zeroio_node.sh to install all tools and source code required for the node in the infrastructure that you decide.

# Introduction

This is a Terraform script to easily deploy a ZERO Validator Node in Google Cloud Platform (GCP).

# Configuration

This Terraform script requires to set up several mandatory variables.

General parameters:

| Field | Description | Default value |
|-|-------------------------------|----------------------------|
| environment | Environment type. Three valid values: dev, pre, pro. | dev |
| ssh_user | SSH user for the virtual machine | zeroio |
| ssh_private_key_file | SSH private key to access the instance |  |
| ssh_pub_key_file | SSH public key to access the instance |  |

Google Cloud Platform related parameters:
| Field | Description | Default value |
|-|-------------------------------|----------------------------|
| credentials_file | GCP credentials file |  |
| project |  GCP project id |  |
| region | GCP region | us-central1 |
| zone | GCP zone | us-central1 |
| machine_types | This is a map to set up the machine types to run de VM | 
  {
    dev  = "e2-standard-8"
    test = "n1-highcpu-32"
    prod = "n1-highcpu-32"
  } |

There are several options to perform this configuration.

1. By command line arguments

```
terraform apply -var variable_name="value"
```

2. By creating a terraform.tfvars file

```
project = "cryptocurrencies-313407"
credentials_file = "keys/gcp-cryptocurrencies.json"
ssh_private_key_file = "keys/gcp_zeroio"
ssh_pub_key_file = "keys/gcp_zeroio.pub"
```

| Field | Description | Sample value |
|-|-------------------------------|----------------------------|
| project |  GCP project id | myprojectid-912207 |
| credentials_file | GCP credentials file | keys/gcp-cryptocurrencies.json |
| ssh_private_key_file | SSH private key to access the instance | keys/gcp_zeroio |
| ssh_pub_key_file | SSH public key to access the instance | keys/gcp_zeroio.pub |

## Terraform script
1. GENERATE GOOGLE CLOUD PLATFORM KEYS

Follow the instructions here https://cloud.google.com/docs/authentication/getting-started to generate the JSON file with credentials.

2. GENERATE PUBLIC/PRIVATE SSH KEYS

   Windows: https://phoenixnap.com/kb/generate-ssh-key-windows-10
   OS X / LINUX: https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-openssh-on-macos-or-linux

3. EXECUTE TERRAFORM

```
terraform plan
terraform apply 
```

## Bash Script to run Zero Validator Node

This script it's inside `scripts/` directory.

You need to configure four variables:

```
export NODENAME=MYZERONODE
export NODEID=0
export SUBDOMAIN=subdomain
export DOMAIN=domain.net
```


| Field | Description | Sample value |
|-|-|-|
| NODENAME |  Prefix for your zero validator node | myprojectid-912207 |
| NODEID | Unique identifier if you want to deploy several zero validator nodes | keys/gcp-cryptocurrencies.json |
| SUBDOMAIN | SSH private key to access the instance | subdomain |
| DOMAIN | SSH public key to access the instance | domain.com |

NODENAME and NODEID will be used together with SUBDOMAIN in order to configure the node name in telemetry as follow: NODENAME-NODEID-SUBDOMAIN-auto

Both of SUBDOMAIN and DOMAIN will be also used to configure letsencrypt and Apache server.

# Execution

```
terraform apply
```


# License

Copyright 2021 Enrique Mendoza @EnriMR

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.