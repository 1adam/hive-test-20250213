module "webhost" {
  source = "./modules/webhost/"

  # !! NOTE !! # variables are explicitly defined in `terraform.tfvars` and defaults are defined in `variables.tf`

  environment = var.env
  namespace   = var.namespace

  vpc_cidr_block    = var.vpc_cidr
  sub1_cidr         = var.subnet1_cidr
  sub2_cidr         = var.subnet2_cidr
  sub1_az           = var.subnet1_az
  sub2_az           = var.subnet2_az
  docker_image      = var.ecs_image
  ecs_port          = var.webserver_port
  ecs_cpu           = var.cpu_units
  ecs_mem           = var.mem_units
  ecs_desired_tasks = var.desired_tasks
}
