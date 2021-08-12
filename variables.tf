# Environment
variable "env" {
  description = "Environment"
  type        = string
}

# Security VPC details
variable "security_vpc" {
  description = "Details for the security VPC"
  type = object({
    name            = string
    cidr            = string
    azs             = list(string)
    private_subnets = list(string)
    public_subnets  = list(string)
    enable_natgw    = bool
    enable_vgw      = bool
    create_igw      = bool
  })
}

# Transit gateway subnets - /28's
variable "tgw_subnets" {
  description = "Transit gateway (TGW) subnets in which the TGW ENIs will reside"
  type        = map(any)
}

# Gateway load balancer subnets - /28's
variable "gwlb_subnets" {
  description = "Gateway load balancer (GWLB) subnets in which the GWLB ENIs will reside"
  type        = map(any)
}
