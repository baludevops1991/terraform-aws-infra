# Create an OpenVPN EC2 instance

data "aws_ami" "amazon_linux_openvpn" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "openvpn_server" {
  ami             = data.aws_ami.amazon_linux.id    # Replace with the OpenVPN AMI ID or a custom image.
  instance_type   = "t2.micro"                      # Adjust the instance type as needed
  subnet_id       = aws_subnet.public-subnets[1].id # Public Subnet 2 (index 1 in the list)
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  key_name        = var.key_name

  tags = {
    Name = "openvpn-server"
  }

  # Configure the OpenVPN server (for example, using user data script)
  user_data = <<-EOF
              #!/bin/bash
              # Install OpenVPN and setup commands (example for Ubuntu)
              sudo apt-get update
              sudo apt-get install -y openvpn easy-rsa
              # Additional setup commands to configure OpenVPN server
              EOF

  # Optional: Assign Elastic IP to the OpenVPN server
  associate_public_ip_address = true
}

# Elastic IP for the OpenVPN server (optional, if you need a static IP)
resource "aws_eip" "openvpn_eip" {
  instance = aws_instance.openvpn_server.id
  vpc      = true
}
