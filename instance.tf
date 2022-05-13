##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
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


  tags = merge(local.common_tags, { Name = "${var.cName}-WebServer"})
}

