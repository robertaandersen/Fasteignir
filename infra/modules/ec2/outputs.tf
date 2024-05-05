output "primary_network_interface_id" {
  value = aws_instance.ec2_instance.primary_network_interface_id

}

output "ec2_instance_id" {
  value = aws_instance.ec2_instance.id
}