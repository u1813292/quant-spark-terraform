# Security Groups

# Ingress rules are for the traffic that enters the boundary of a network. Egress rules imply to traffic exits instance or network. Configuring security group to allow ssh and http access.

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow http inbound traffic and ssh for setup"

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # TODO: Add IP access limiting to prevent random ssh access attempts. Preferably to the hosting of our local IP so remote access requires vpn
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }
}
