region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

#environment = "dev"

keypair = "pbl-projects"

# Ensure to change this to your acccount number
account_no = ""

master-username = "wale"

master-password = "devopspbl"

tags = {
  Enviroment      = "dev"
  Owner-Email     = "random_email@protonmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "" #Add the Billing AWS Account here
}