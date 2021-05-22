locals {
  max_subnet_length = max(
    length(var.private_subnets)
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
  vpc_id = element(
    concat(
#      aws_vpc_ipv4_cidr_block_association.this.*.vpc_id,
      aws_vpc.vpc.*.id,
      [""],
    ),
    0,
  )
}

resource "aws_vpc" "vpc" {
  count = var.create_vpc ? 1 : 0
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = format("%s", var.vpc_name)
    },
    var.tags,
    var.vpc_tags,
  )
}
