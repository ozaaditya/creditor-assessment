variable "node_instance_type" {
  description = "The EC2 instance type for the nodes"
  type        = string
}

variable "desired_capacity" {
  description = "The desired number of nodes in the node group"
  type        = number
}

variable "node_group_name" {
  description = "The name of the self-managed node group"
  type        = string
}