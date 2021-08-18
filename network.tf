// Route Tables
resource "aws_route_table" "gwlbrt" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "gwlb-rt"
  }
}

resource "aws_route_table" "tgwrt1" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "tgw-rt1"
  }
}

resource "aws_route_table" "tgwrt2" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "tgw-rt2"
  }
}

// Transit gateway ENI Routes
resource "aws_route" "tgw_route1" {
  route_table_id         = aws_route_table.tgwrt1.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlb1.id
}

resource "aws_route" "tgw_route2" {
  route_table_id         = aws_route_table.tgwrt2.id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlb2.id
}

// Public subnets default route
resource "aws_route" "externalroute1" {
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.igw_id
}

// Gateway load balancer internal/external routes

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
  gateway_id   = module.vpc.igw_id
}

// Route table subnet associations

// Transit gateway subnets
resource "aws_route_table_association" "tgwassociate1" {
  subnet_id      = aws_subnet.tgw_subnets["tgw_az1"].id
  route_table_id = aws_route_table.tgwrt1.id
}

resource "aws_route_table_association" "tgwassociate2" {
  subnet_id      = aws_subnet.tgw_subnets["tgw_az2"].id
  route_table_id = aws_route_table.tgwrt2.id
}

// Gateway load balancer subnets
resource "aws_route_table_association" "gwlbassociate1" {
  subnet_id      = aws_subnet.gwlb_subnets["gwlb_az1"].id
  route_table_id = aws_route_table.gwlbrt.id
}

resource "aws_route_table_association" "gwlbassociate2" {
  subnet_id      = aws_subnet.gwlb_subnets["gwlb_az2"].id
  route_table_id = aws_route_table.gwlbrt.id
}

// Security Group

resource "aws_security_group" "allow_mgmt" {
  name        = "foritgate-mgmt-sg"
  description = "fortigate-mgmt-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["71.191.92.96/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["71.191.92.96/32"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "6"
    # cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["71.191.92.96/32"]
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
}

resource "aws_eip" "FGT1PublicIP" {
  depends_on        = [aws_instance.fgtvm1]
  vpc               = true
  network_interface = aws_network_interface.fg1_eth0.id
}

resource "aws_eip" "FGT2PublicIP" {
  depends_on        = [aws_instance.fgtvm2]
  vpc               = true
  network_interface = aws_network_interface.fg2_eth0.id
}

