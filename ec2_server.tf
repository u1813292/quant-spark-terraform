resource "aws_instance" "webserver" {
  ami             = "ami-0fe0b2cf0e1f25c8a"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.webserver_key.key_name
  security_groups = [aws_security_group.allow_http_ssh.name]
  tags = {
    Name = "webserver_instance"
  }
  root_block_device {
    delete_on_termination = false
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.webserver.public_ip
    port        = 22
    private_key = tls_private_key.webserver_private_key.private_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd php -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
    ]
  }
}
