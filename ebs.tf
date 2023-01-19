resource "aws_ebs_volume" "webserver_ebs" {
  availability_zone = aws_instance.webserver.availability_zone
  size              = 1
  tags = {
    Name = "webserver-persistent-store"
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name  = "/dev/xvdf"
  volume_id    = aws_ebs_volume.webserver_ebs.id
  instance_id  = aws_instance.webserver.id
  force_detach = true
  depends_on   = [aws_ebs_volume.webserver_ebs, aws_instance.webserver, aws_cloudfront_distribution.s3_distribution]

  provisioner "local-exec" {
    command = "sed 's/@DOMAIN@/${aws_cloudfront_distribution.s3_distribution.domain_name}/g' base.html > index.html"
  }
  provisioner "file" {
    source      = "index.html"
    destination = "/home/ec2-user/index.html"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.webserver.public_ip
      port        = 22
      private_key = tls_private_key.webserver_private_key.private_key_pem
    }
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
      "sudo mkfs.ext4 ${aws_volume_attachment.ebs_attachment.device_name}",
      "sudo mount ${aws_volume_attachment.ebs_attachment.device_name} /var/www/html",
      "sudo mv /home/ec2-user/index.html /var/www/html/index.html",
      "sudo systemctl restart httpd"
    ]
  }
}

output "IP" {
  depends_on = [
    aws_volume_attachment.ebs_attachment,
    aws_ebs_volume.webserver_ebs,
    aws_instance.webserver,
    aws_cloudfront_distribution.s3_distribution
  ]
  value = aws_instance.webserver.public_ip
}
