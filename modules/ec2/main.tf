resource "aws_instance" "ec2" {
  ami = var.AMI_ID
  instance_type = var.INSTANCE_TYPE

  subnet_id = var.SUBNET_ID
  vpc_security_group_ids = var.VPC_SECURITY_GROUP
  
  # ssh public key
  key_name = aws_key_pair.key_pair.id

  provisioner "file" {
    source = var.PROVISIONER_FILE
    destination = "/tmp/provisioner.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provisioner.sh",
      "sudo /tmp/provisioner.sh",
    ]
  }

  connection {
    user = var.EC2_USER
    host = self.public_ip
    private_key = var.PRIVATE_KEY
  }
}

resource "aws_key_pair" "key_pair" {
  key_name = "key-pair"
  #public_key = file("${path.module}/../infrastructure/${var.PUBLIC_KEY_PATH}")
  public_key = var.PUBLIC_KEY_PATH
}
