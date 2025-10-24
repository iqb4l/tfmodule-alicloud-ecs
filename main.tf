# Create Security Group if rules are provided
resource "alicloud_security_group" "ecs_sg" {
  count               = length(var.security_group_rules) > 0 ? 1 : 0
  vpc_id              = var.vpc_id
  security_group_name = "${var.instance_name}-sg"
  description         = var.security_group_description
}

# Create Security Group Rules
resource "alicloud_security_group_rule" "rules" {
  for_each = { 
    for idx, rule in var.security_group_rules : 
    "${rule.type}-${rule.ip_protocol}-${idx}" => rule 
  }
  
  type              = each.value.type
  ip_protocol       = lookup(each.value, "ip_protocol", "tcp")
  nic_type          = lookup(each.value, "nic_type", "intranet")
  policy            = lookup(each.value, "policy", "accept")
  port_range        = each.value.port_range
  priority          = lookup(each.value, "priority", 1)
  security_group_id = alicloud_security_group.ecs_sg[0].id
  cidr_ip           = lookup(each.value, "cidr_ip", null)
  description       = lookup(each.value, "description", "")
}

# Create ECS Instance
resource "alicloud_instance" "instance" {
  instance_name              = var.instance_name
  instance_type              = var.instance_type
  image_id                   = var.image_id
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  vswitch_id                 = var.vswitch_id
  security_groups            = var.security_group_ids != null ? var.security_group_ids : [alicloud_security_group.ecs_sg[0].id]
  internet_max_bandwidth_out = var.internet_max_bandwidth_out
  password                   = var.password
  key_name                   = var.key_name
  instance_charge_type       = var.instance_charge_type
  private_ip                 = var.private_ip != null ? var.private_ip : null

  # Optional data disks
  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      size                 = lookup(data_disks.value, "size", var.system_disk_size)
      category             = lookup(data_disks.value, "category", var.system_disk_category)
      delete_with_instance = lookup(data_disks.value, "delete_with_instance", true)
      encrypted            = lookup(data_disks.value, "encrypted", false)
    }
  }
}


# Allocate EIP if requested
resource "alicloud_eip_address" "eip" {
  count                = var.allocate_public_ip ? 1 : 0
  address_name         = "${var.instance_name}-eip"
  bandwidth            = var.eip_bandwidth
  internet_charge_type = var.eip_internet_charge_type
  payment_type         = var.eip_payment_type
}

# Associate EIP with instance
resource "alicloud_eip_association" "eip_assoc" {
  count         = var.allocate_public_ip ? 1 : 0
  allocation_id = alicloud_eip_address.eip[0].id
  instance_id   = alicloud_instance.instance.id
}