module "security_groups" {
    source = "./security_groups"
    security_groups = local.security_groups
    vpc = data.terraform_remote_state.fundation.outputs.vpc_id
}

module "network_load_balancer" {
  source = "./load_balancer"
  loadb_description = local.loadb_description
  target_description = local.target_group
  vpc_id = data.terraform_remote_state.fundation.outputs.vpc_id
}