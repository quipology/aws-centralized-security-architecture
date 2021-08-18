// FGTVM instance 1

resource "aws_network_interface" "fg2_eth0" {
  description = "fgtvm-port1"
  subnet_id   = module.vpc.public_subnets[1]
}

resource "aws_network_interface" "fg2_eth1" {
  description       = "fgtvm-port2"
  subnet_id         = module.vpc.private_subnets[1]
  source_dest_check = false
}


resource "aws_network_interface_sg_attachment" "publicattachment2" {
  depends_on           = [aws_network_interface.fg2_eth0]
  security_group_id    = aws_security_group.allow_mgmt.id
  network_interface_id = aws_network_interface.fg2_eth0.id
}

resource "aws_network_interface_sg_attachment" "internalattachment2" {
  depends_on           = [aws_network_interface.fg2_eth1]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.fg2_eth1.id
}


resource "aws_instance" "fgtvm2" {
  ami               = var.license_type == "byol" ? var.fgtvmbyolami[var.region] : var.fgtvmami[var.region]
  instance_type     = var.size
  availability_zone = var.security_vpc.azs[1]
#   key_name          = var.keyname
  user_data         = data.template_file.FortiGate.rendered

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.fg2_eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.fg2_eth1.id
    device_index         = 1
  }

  tags = {
    Name = "FortiGateVM-2"
  }
}


data "template_file" "FortiGate2" {
  template = file(var.bootstrap-fgtvm)
  vars = {
    type         = var.license_type
    license_file = var.license
    adminsport   = var.adminsport
  }
}