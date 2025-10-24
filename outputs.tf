output "instance_id" {
  value = alicloud_instance.instance.id
}

output "private_ip" {
  value = alicloud_instance.instance.private_ip
}

output "public_ip" {
  value = var.allocate_public_ip ? alicloud_eip_address.eip[0].ip_address : null
}

output "security_group_id" {
  value = length(var.security_group_rules) > 0 ? alicloud_security_group.ecs_sg[0].id : null
}