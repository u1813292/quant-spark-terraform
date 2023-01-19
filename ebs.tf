# EBS
# We want to store code in persistent storage so that instance termination could not affect it.

resource "aws_ebs_volume" "webserver_ebs" {
  availability_zone = aws_instance.webserver.availability_zone
  size              = 1
  tags = {
    Name = "webserver-persistent-store"
  }
}

# Attach to ec2 instance

# This resource has dependency on EBS volume and instance. Because until they are not created we can not attach them. while destroying if the volume is attached to the instance we can not destroy it gives ‘volume is busy’ error. for that, we used force_detach = true.

resource "aws_volume_attachment" "ebs_attachment" {
  device_name  = "/dev/xvdf"
  volume_id    = aws_ebs_volume.webserver_ebs.id
  instance_id  = aws_instance.webserver.id
  force_detach = true
  depends_on   = [aws_ebs_volume.webserver_ebs, aws_instance.webserver]
}
