variable "ubuntu_ami" {
  description = "AMI ID for Ubuntu Server 22.04 LTS"
  type        = string
  default     = "ami-005fc0f236362e99f"  # Replace with a valid AMI ID as needed
}

variable "keypair_name" {
  description = "Name of the key pair to use"
  type        = string
  default     = "terraform-keypair"  # Replace with your key pair name
}

