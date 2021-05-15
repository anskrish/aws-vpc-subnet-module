provider "aws" {
  region = local.region
}

locals {
  name   = "ops"
  region = "us-west-2"
  tags = {
    Owner = "krishna.rudraraju"
    Environment = "ops"
  }
}

module "vpc" {
  source = "../."
  create_vpc = true
  vpc_name = local.name
  vpc_cidr = "10.1.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink  = true
  enable_classiclink_dns_support = true

  azs = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = ["10.1.0.0/24"]
  tags = local.tags
  public_subnet_tags = {
    Name = "ops-public-subnet"
  }
}
