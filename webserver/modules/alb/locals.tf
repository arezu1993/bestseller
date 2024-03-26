locals {
  owners = "Arezoo"
  name = "${local.owners}-assignment"
  common_tags = {
    owners = local.owners
    name = local.name
  }

} 
