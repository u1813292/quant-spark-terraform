resource "null_resource" "nullremote" {
  depends_on = [aws_volume_attachment.ebs_attachment, aws_cloudfront_distribution.s3_distribution, aws_instance.webserver]
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
      "sudo sed -i 's/@DOMAIN@/${aws_cloudfront_distribution.s3_distribution.domain_name}/g' /home/ec2-user/test.html",
      "sudo cp /home/ec2-user/test.html /var/www/html/index.html",
      "sudo systemctl restart httpd"
    ]
  }
}
