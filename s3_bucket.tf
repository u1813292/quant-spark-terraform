# S3

# We used terraform’s resource ‘aws_s3_bucket’ to create a bucket. To create a s3 bucket you must give a unique name to the bucket. ‘Here’s bucket name is ‘website-images-res’.

resource "aws_s3_bucket" "webserver_images_bucket" {
  bucket = "webserver-images-quant-spark-int"
  tags = {
    Name        = "Image Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.webserver_images_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "hire_image" {
  bucket     = aws_s3_bucket.webserver_images_bucket.bucket
  key        = "hire-me.jpg"
  source     = "images/hire-me.jpg"
  acl        = "public-read"
  depends_on = [aws_s3_bucket.webserver_images_bucket]
}
