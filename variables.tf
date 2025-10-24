variable "instance_name" {
  type        = string
  description = "Name of the ECS instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "image_id" {
  type        = string
  description = "Image ID for the instance"
}

variable "vswitch_id" {
  type        = string
  description = "VSwitch ID"
}

variable "system_disk_category" {
  type        = string
  description = "System disk category"
}

variable "system_disk_size" {
  type        = number
  description = "System disk size in GB"
}

variable "security_group_ids" {
  type        = list(string)
  description = "security group IDs "
}

variable "internet_max_bandwidth_out" {
  type        = number
  description = "Maximum outbound bandwidth to the Internet"
}

variable "password" {
  type        = string
  description = "Instance password"
  sensitive   = true
  default     = null
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
  default     = null
}

variable "instance_charge_type" {
  type        = string
  description = "Instance charge type"
}


variable "data_disks" {
  type = list(object({
    size                 = number
    category             = optional(string)
    delete_with_instance = optional(bool)
    encrypted            = optional(bool)
  }))
  description = "List of data disks"
  default     = []
}

variable "user_data" {
  type        = string
  description = "User data script"
  default     = null
}

variable "allocate_public_ip" {
  type        = bool
  description = "Whether to allocate a public IP"
}

variable "private_ip" {
  description = "Optional private IP address to assign to the ECS instance within the vSwitch CIDR block"
  type        = string
  default     = null
}

variable "eip_bandwidth" {
  type        = number
  description = "EIP bandwidth"
}

variable "eip_internet_charge_type" {
  type        = string
  description = "EIP charge type"
}

variable "eip_payment_type" {
  type        = string
  description = "EIP payment type"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the instance"
  default     = {}
}