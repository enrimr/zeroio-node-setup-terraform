# CONFIGURATION

This Terraform script requires to set up several mandatory variables. To configure that, there are several options.

1. By command line arguments

terraform apply -var variable_name="value"

2. By creating a terraform.tfvars file

`project = "cryptocurrencies-313407"
credentials_file = "keys/gcp-cryptocurrencies.json"
ssh_private_key_file = "keys/gcp_zeroio"
ssh_pub_key_file = "keys/gcp_zeroio.pub"`


| Field | Description | Sample value |
|-|:-------------------------------:|----------------------------:|
| project |  GCP project id | myprojectid-912207 |
| credentials_file | GCP credentials file | keys/gcp-cryptocurrencies.json |
| ssh_private_key_file | SSH private key to access the instance | keys/gcp_zeroio |
| ssh_pub_key_file | SSH public key to access the instance | keys/gcp_zeroio.pub |

## TERRAFORM
1. GENERATE GOOGLE CLOUD PLATFORM KEYS

Follow the instructions here https://cloud.google.com/docs/authentication/getting-started to generate the JSON file with credentials.

2. GENERATE PUBLIC/PRIVATE SSH KEYS
   Windows: https://phoenixnap.com/kb/generate-ssh-key-windows-10
   OS X / LINUX: https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-openssh-on-macos-or-linux

3. EXECUTE TERRAFORM

` terraform plan `

` terraform apply `

## SCRIPT TO RUN ZERO.IO NODE

This script it's inside scripts/ directory.

You need to configure four variables:

export NODENAME=MYZERONODE
export NODEID=0
export SUBDOMAIN=subdomain
export DOMAIN=domain.net

| Field | Description | Sample value |
|-|:-------------------------------:|----------------------------:|
| NODENAME |  Prefix for your zero validator node | myprojectid-912207 |
| NODEID | Unique identifier if you want to deploy several zero validator nodes | keys/gcp-cryptocurrencies.json |
| SUBDOMAIN | SSH private key to access the instance | subdomain |
| DOMAIN | SSH public key to access the instance | domain.com |

NODENAME and NODEID will be used together with SUBDOMAIN in order to configure the node name in telemetry as follow: NODENAME-NODEID-SUBDOMAIN

Both of SUBDOMAIN and DOMAIN will be also used to configure letsencrypt and Apache server.

# EXECUTION

` terraform apply`
