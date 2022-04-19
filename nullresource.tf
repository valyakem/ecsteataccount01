resource "null_resource" "create-s3" {
  provisioner "local-exec" {
        command = "aws create-bucket --acl public-read-write --bucket testbucketnull"
  }
}