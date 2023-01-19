# SSH Key generation

# resource ‘tls_private_key’ to create private key saved locally with the name ‘webserver_key.pem’. Then to create ‘AWS Key Pair’ we used resource ‘aws_key_pair’ and used our private key here as public key.

resource "tls_private_key" "webserver_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.webserver_private_key.private_key_pem
  filename        = "webserver_key.pem"
  file_permission = 0400
}

resource "aws_key_pair" "webserver_key" {
  key_name   = "webserver"
  public_key = tls_private_key.webserver_private_key.public_key_openssh
}
