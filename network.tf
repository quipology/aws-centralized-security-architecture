// Route Table
resource "aws_route_table" "gwlbrt" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "gwlb-rt"
  }
}

// Routes
resource "aws_route" "externalroute1" {
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.igw_id
}

resource "aws_route" "internalroute1" {
#   depends_on             = [aws_instance.fgtvm1]
  route_table_id         = aws_route_table.gwlbrt.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id   = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "externalroute2" {
#   depends_on             = [aws_instance.fgtvm1]
  route_table_id         = aws_route_table.gwlbrt.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id   = module.vpc.igw_id
}


# resource "aws_route" "internalroute2" {
# #   depends_on             = [aws_instance.fgtvm1]
#   route_table_id         = module.vpc.private_route_table_ids[1]
#   destination_cidr_block = "10.0.0.0/8"
#   transit_gateway_id   = aws_ec2_transit_gateway.tgw.id
# }

# resource "aws_route" "internalroute3" {
# #   depends_on             = [aws_instance.fgtvm1]
#   route_table_id         = module.vpc.private_route_table_ids[0]
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = module.vpc.igw_id
# }

# resource "aws_route" "internalroute4" {
# #   depends_on             = [aws_instance.fgtvm1]
#   route_table_id         = module.vpc.private_route_table_ids[1]
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = module.vpc.igw_id
# }

// Security Group

resource "aws_security_group" "public_allow" {
  name        = "foritgate-mgmt-sg"
  description = "fortigate-mgmt-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fortigate-mgmt-sg"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "fortigate-ingress-sg"
  description = "fortigate-ingress-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fortigate-ingress-sg"
  }
// Route Table
# resource "aws_route_table" "fgtvmpublicrt" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "fgtvm-public-rt"
#   }
# }

# resource "aws_route_table" "fgtvmprivatert" {
#   vpc_id = module.vpc.vpc_id

#   tags = {
#     Name = "fgtvm-private-rt"
#   }
# }

# resource "aws_route" "externalroute" {
#   route_table_id         = module.vpc.private_route_table_ids[1]
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = module.vpc.igw_id
# }
# resource "aws_route" "externalroute" {
#   route_table_id         = aws_route_table.fgtvmpublicrt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = module.vpc.igw_id
# }


# resource "aws_route" "internalroute2" {
#   depends_on             = [aws_instance.fgtvm1]
#   route_table_id         = module.vpc.private_route_table_ids[1]
#   destination_cidr_block = "0.0.0.0/0"
#   vpc_endpoint_id   = aws_vpc_endpoint.gwlb.id
# }

# resource "aws_route_table_association" "publicassociate1" {
#   subnet_id      = module.vpc.public_subnets[0]
#   route_table_id = aws_route_table.fgtvmpublicrt.id
# }

# resource "aws_route_table_association" "internalassociate1" {
#   subnet_id      = module.vpc.private_subnets[0]
#   route_table_id = aws_route_table.fgtvmprivatert.id
# }

# resource "aws_eip" "FGT1PublicIP" {
#   depends_on        = [aws_instance.fgtvm1]
#   vpc               = true
#   network_interface = aws_network_interface.fg1_eth0.id
# }

# resource "aws_route_table_association" "publicassociate2" {
#   subnet_id      = module.vpc.public_subnets[1]
#   route_table_id = aws_route_table.fgtvmpublicrt.id
# }

# resource "aws_route_table_association" "internalassociate2" {
#   subnet_id      = module.vpc.private_subnets[1]
#   route_table_id = aws_route_table.fgtvmprivatert.id
# }

# resource "aws_eip" "FGT2PublicIP" {
#   depends_on        = [aws_instance.fgtvm1]
#   vpc               = true
#   network_interface = aws_network_interface.fg2_eth0.id
# }
}