moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}

moved {
  from = aws_subnet.public_a
  to   = module.network.aws_subnet.public_a
}

moved {
  from = aws_subnet.public_b
  to   = module.network.aws_subnet.public_b
}

moved {
  from = aws_subnet.private_a
  to   = module.network.aws_subnet.private_a
}

moved {
  from = aws_subnet.private_b
  to   = module.network.aws_subnet.private_b
}

moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}

moved {
  from = aws_eip.nat
  to   = module.network.aws_eip.nat
}

moved {
  from = aws_nat_gateway.main
  to   = module.network.aws_nat_gateway.main
}

moved {
  from = aws_route_table.private
  to   = module.network.aws_route_table.private
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table_association.private_a
  to   = module.network.aws_route_table_association.private_a
}

moved {
  from = aws_route_table_association.private_b
  to   = module.network.aws_route_table_association.private_b
}

moved {
  from = aws_route_table_association.public_a
  to   = module.network.aws_route_table_association.public_a
}

moved {
  from = aws_route_table_association.public_b
  to   = module.network.aws_route_table_association.public_b
}