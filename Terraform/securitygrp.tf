# Create a Security Group
resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.new_vpc.id  # Associate with the new VPC

  tags = {
    Name = "demo-sg"
  }
}

resource "aws_security_group_rule" "demo_sg_ssh_ingress" {
  description = "ssh access"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Allow SSH from anywhere (consider limiting this)
  security_group_id = aws_security_group.demo_sg.id
}

resource "aws_security_group_rule" "demo_sg_jenkins_ingress" {
  description = "jenkins port"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Allow SSH from anywhere (consider limiting this)
  security_group_id = aws_security_group.demo_sg.id
}

resource "aws_security_group_rule" "allow_all_traffic_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  # Allow all outbound traffic
  cidr_blocks       = ["0.0.0.0/0"]  # Allow all outbound traffic
  security_group_id = aws_security_group.demo_sg.id
}