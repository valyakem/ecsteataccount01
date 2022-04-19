resource "null_resource" "create-s3" {
  provisioner "local-exec" {
        command = "aws s3api create-bucket --bucket testbucketname --region us-east-1"
  }
}