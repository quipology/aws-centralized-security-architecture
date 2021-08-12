output "root_tgw_id" {
    description = "Root transit gateway id"
    value = aws_ec2_transit_gateway.tgw.id
}