# Environment
variable "env" {
  description = "Environment"
  type        = string
}

variable "region" {
  type = string
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

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default     = "payg"
}

// AMIs are for FGTVM-AWS(PAYG) - 6.4.5
variable "fgtvmami" {
  type = map
  default = {
    us-west-2      = "ami-0bd63e9b6f030819a"
    us-west-1      = "ami-0109010188b5b573b"
    us-east-1      = "ami-08ea233f6c1af5e84"
    us-east-2      = "ami-04c250698411252c9"
    ap-east-1      = "ami-0f86b4d9e4042517c"
    ap-south-1     = "ami-02623434e90a4eb94"
    ap-northeast-3 = "ami-0dad396c8a078d79a"
    ap-northeast-2 = "ami-09e9c92b84ea58aaf"
    ap-southeast-1 = "ami-086e03d1b2585d1d8"
    ap-southeast-2 = "ami-097983da0f89a0165"
    ap-northeast-1 = "ami-03d14586c97618b09"
    ca-central-1   = "ami-09cd0ee65f8a7cbd6"
    eu-central-1   = "ami-0479cc1e690725514"
    eu-west-1      = "ami-04acaa2b439d0ab7a"
    eu-west-2      = "ami-00f80eeec7920b5ab"
    eu-south-1     = "ami-001b7d48c8f37d191"
    eu-west-3      = "ami-0105ba9c9d7df062e"
    eu-north-1     = "ami-05472a2645b39adce"
    me-south-1     = "ami-037ce9c4a95c5a335"
    sa-east-1      = "ami-025e01b791a5b0bd6"
  }
}


// AMIs are for FGTVM AWS(BYOL) - 6.4.5
variable "fgtvmbyolami" {
  type = map
  default = {
    us-west-2      = "ami-093c91ef5edce49a6"
    us-west-1      = "ami-0abf93087b8b6039c"
    us-east-1      = "ami-07e907b5ae3b6ad27"
    us-east-2      = "ami-0369456bca7679c37"
    ap-east-1      = "ami-0607c244f54cebd77"
    ap-south-1     = "ami-0ab141906704f2a51"
    ap-northeast-3 = "ami-0fa22d36cbb805b1d"
    ap-northeast-2 = "ami-036c90e71abd027ba"
    ap-southeast-1 = "ami-0cd6daf941ce15238"
    ap-southeast-2 = "ami-05fcd1eda54018e13"
    ap-northeast-1 = "ami-0b8771d8318131ea0"
    ca-central-1   = "ami-0c4cecd2e2f91c577"
    eu-central-1   = "ami-0e3b4279c34108da8"
    eu-west-1      = "ami-0c3fd9d2d765f52d7"
    eu-west-2      = "ami-01e98c30685d313a9"
    eu-south-1     = "ami-01c4700850d722eef"
    eu-west-3      = "ami-05fb5ba112997f4c4"
    eu-north-1     = "ami-0d2ff02042bdbaa74"
    me-south-1     = "ami-001a8c09bb54d3afc"
    sa-east-1      = "ami-09fe162de6d31c4de"
  }
}

variable "size" {
  default = "c5n.xlarge"
}

//  Existing SSH Key on the AWS 
# variable "keyname" {
#   default = "<AWS SSH key>"
# }

variable "adminsport" {
  default = "8443"
}

variable "bootstrap-fgtvm" {
  // Change to your own path
  type    = string
  default = "fgtvm.conf"
}

// license file for the active fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.lic"
}