##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220426.0-x86_64-gp2"]
  }


}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "Web_Server" {
  count = var.count_instance
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]
  subnet_id = aws_subnet.Public_Sunnet[count.index].id
  
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo usermod -a -G apache ec2-user",
      "sudo chown -R ec2-user:apache /var/www",
      "sudo chmod 2775 /var/www",
      "find /var/www -type d -exec sudo chmod 2775 {} \\;",
      "find /var/www -type f -exec sudo chmod 0664 {} \\;",
      "cd /var/www",
      "mkdir inc",
      "cd inc",

      

    ]
  }
  tags = merge(local.common_tags, { Name = "${var.cName}-WebServer"})
}

