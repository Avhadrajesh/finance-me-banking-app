# Create EC2 Instances
resource "aws_instance" "ec2_terra" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)  # Use the lookup function to fetch the AMI based on the region
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.mykeypair.key_name  # Reference the key pair by its name
  subnet_id               = aws_subnet.terra_vpc_public_1.id  # Reference the VPC subnet for the EC2 instance
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]  # Reference the security group ID for SSH access
  
  for_each                = toset(["jenkins-master", "jenkins-slave", "ansible"])  # Create 3 instances: jenkins-master, jenkins-slave, ansible

  # Tags for EC2 instances
  tags = {
    Name        = each.key                        # Dynamically assign the name for each instance
    Environment = "Development"                   # Additional tag to specify the environment
  }

  # Uncomment and set the user_data if needed
  # user_data = data.cloudinit_config.cloudinit-first-demo.rendered
}

# Output EC2 Instance Public IPs
output "ec2_terra_ips" {
  value = aws_instance.ec2_terra.*.public_ip               # Output the public IPs of all EC2 instances
}
