# Create ECS Instance
resource "alicloud_instance" "instance" {
  instance_name              = var.instance_name
  instance_type              = var.instance_type
  image_id                   = var.image_id
  system_disk_category       = var.system_disk_category
  system_disk_size           = var.system_disk_size
  vswitch_id                 = var.vswitch_id
  security_groups            = var.security_group_ids
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