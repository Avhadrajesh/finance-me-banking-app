# Configure the AWS provider
provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

# Create a new VPC
resource "aws_vpc" "Terra_vpc" {
  cidr_block = "10.0.0.0/16"  # Adjust CIDR block as needed

  tags = {
    Name = "Terra-vpc"
  }
}

# Create the first Public Subnet
resource "aws_subnet" "Terra_public_subnet_01" {
  vpc_id                  = aws_vpc.Terra_vpc.id
  cidr_block              = "10.0.1.0/24"  # Adjust CIDR block as needed
  availability_zone       = "us-east-1a"   # Specify the availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "terra-subnet-1"
  }
}

# Create the second Public Subnet
resource "aws_subnet" "Terra_public_subnet_02" {
  vpc_id                  = aws_vpc.Terra_vpc.id
  cidr_block              = "10.0.2.0/24"  # Adjust CIDR block as needed
  availability_zone       = "us-east-1b"   # Specify another availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "terra-subnet-2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "Terra_igw" {
  vpc_id = aws_vpc.Terra_vpc.id

  tags = {
    Name = "terra-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "Terra_rt" {
  vpc_id = aws_vpc.Terra_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terra_igw.id
  }

  tags = {
    Name = "Terra-route-table"
  }
}

# Create Route Table Association for the first subnet
resource "aws_route_table_association" "terra_rta_1" {
  subnet_id      = aws_subnet.Terra_public_subnet_01.id
  route_table_id = aws_route_table.Terra_rt.id
}

# Create Route Table Association for the second subnet
resource "aws_route_table_association" "terra_rta_2" {
  subnet_id      = aws_subnet.Terra_public_subnet_02.id
  route_table_id = aws_route_table.Terra_rt.id
}

# Create a Security Group
resource "aws_security_group" "Terra_sg" {
  name        = "Terra-sg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Terra_vpc.id  # Associate with the new VPC

  tags = {
    Name = "Terra-sg"
  }
}

resource "aws_security_group_rule" "Terra_sg_ssh_ingress" {
  description = "SSH access"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (consider limiting this)
  security_group_id = aws_security_group.Terra_sg.id
}

resource "aws_security_group_rule" "Terra_sg_jenkins_ingress" {
  description = "Jenkins port"
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (consider limiting this)
  security_group_id = aws_security_group.Terra_sg.id
}

resource "aws_security_group_rule" "allow_all_traffic_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  # Allow all outbound traffic
  cidr_blocks       = ["0.0.0.0/0"]  # Allow all outbound traffic
  security_group_id = aws_security_group.Terra_sg.id
}

# Create EC2 Instances
resource "aws_instance" "terraserver" {
  ami                    = var.ubuntu_ami             # Use Ubuntu AMI variable
  instance_type          = "t2.micro"
  key_name               = var.keypair_name          # Use variable for key pair name
  subnet_id              = aws_subnet.Terra_public_subnet_01.id  # Specify the subnet for the instance
  vpc_security_group_ids = [aws_security_group.Terra_sg.id]  # Reference the security group by ID

  for_each               = toset(["jenkins-master","production","build-slave", "ansible"]) # Create 3 instances

  tags = {
    Name        = each.key                  # Use each.key to set unique names for each instance
    Environment = "Development"             # Example tag to specify the environment
  }

  # Uncomment and set the user_data if needed
  # user_data = data.cloudinit_config.cloudinit-first-demo.rendered
}

# Output EC2 Instance Public IPs
output "ec2_terra_ips" {
  value = { for k, v in aws_instance.terraserver : k => v.public_ip }
}
