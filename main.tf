# Security VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.security_vpc.name
  cidr = var.security_vpc.cidr

  azs             = var.security_vpc.azs
  private_subnets = var.security_vpc.private_subnets
  public_subnets  = var.security_vpc.public_subnets

  enable_nat_gateway = var.security_vpc.enable_natgw
  enable_vpn_gateway = var.security_vpc.enable_vgw
  create_igw         = var.security_vpc.create_igw

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

locals {
    tgw_subnet_ids = [aws_subnet.tgw_subnets[keys(var.tgw_subnets)[0]].id, aws_subnet.tgw_subnets[keys(var.tgw_subnets)[1]].id]
    gwlb_subnet_ids = [aws_subnet.gwlb_subnets[keys(var.gwlb_subnets)[0]].id, aws_subnet.gwlb_subnets[keys(var.gwlb_subnets)[1]].id]
}

# Transit gateway
resource "aws_ec2_transit_gateway" "tgw" {
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "root-tgw"
  }
}


# Transit gateway subnets
resource "aws_subnet" "tgw_subnets" {
  for_each   = var.tgw_subnets
  vpc_id     = module.vpc.vpc_id
  cidr_block = each.value.cidr
  tags = {
    Name = each.value.name
  }
}

# Transit gateway security route table
resource "aws_ec2_transit_gateway_route_table" "tgw_security_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
      Name = "security-rt"
  }
}

# Transit gateway spoke route table
resource "aws_ec2_transit_gateway_route_table" "tgw_spoke_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
      Name = "spoke-rt"
  }
}

# Transit gateway attachment to the security VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "security_vpc_att" {
  subnet_ids         = local.tgw_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = module.vpc.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags = {
      Name = "${var.security_vpc.name}-vpc-att"
  }
}

# Transit gateway security VPC route table association
resource "aws_ec2_transit_gateway_route_table_association" "security_vpc_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_att.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_security_rt.id
}

# Transit gateway security VPC spoke table propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "security_vpc_prop" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.security_vpc_att.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_spoke_rt.id
}

# Gateway load balancer subnets
resource "aws_subnet" "gwlb_subnets" {
  for_each   = var.gwlb_subnets
  vpc_id     = module.vpc.vpc_id
  cidr_block = each.value.cidr
  tags = {
    Name = each.value.name
  }
}

