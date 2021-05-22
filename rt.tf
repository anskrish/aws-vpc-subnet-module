resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id
  route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.igw[0].id
    }
  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}", var.vpc_name)
    },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route_table_association" "association" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  count = var.create_vpc && local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.vpc_name}-${var.private_subnet_suffix}" : format(
        "%s-${var.private_subnet_suffix}-%s",
        var.vpc_name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.private_route_table_tags,
  )
}