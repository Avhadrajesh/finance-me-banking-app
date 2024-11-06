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

# variables.tf
variable "AWS_ACCESS_KEY" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true  # Mark this variable as sensitive so Terraform doesn't display it in logs
}

variable "AWS_SECRET_KEY" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true  # Mark this variable as sensitive
}

variable "AWS_REGION" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"  # Example region, adjust as needed
}
