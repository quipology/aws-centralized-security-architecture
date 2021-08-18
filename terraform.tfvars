region  = "us-east-2"

env = "dev"

security_vpc = {
  name            = "security"
  cidr            = "10.42.0.0/16"
  azs             = ["us-east-2a", "us-east-2b"]
  private_subnets = ["10.42.2.0/24", "10.42.4.0/24"]
  public_subnets  = ["10.42.1.0/24", "10.42.3.0/24"]
  enable_natgw    = false
  enable_vgw      = false
  create_igw      = true
}

tgw_subnets = {
  tgw_az1 = {
    name = "tgw-az1"
    cidr = "10.42.6.0/28"
    az = "us-east-2a"
  },
  tgw_az2 = {
    name = "tgw-az2"
    cidr = "10.42.6.16/28"
    az = "us-east-2b"
  }
}

gwlb_subnets = {
  gwlb_az1 = {
    name = "gwlb-az1"
    cidr = "10.42.6.32/28"
    az = "us-east-2a"
  },
  gwlb_az2 = {
    name = "gwlb-az2"
    cidr = "10.42.6.48/28"
    az = "us-east-2b"
  }
}
