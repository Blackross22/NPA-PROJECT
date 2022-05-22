##################################################################################
# RESOURCES
##################################################################################

resource "aws_launch_configuration" "as_conf" {
  name_prefix =  "web_server"
  image_id      = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.allow_ssh_web.id]

  user_data = <<-EOT
  #!/bin/bash

  sudo yum update -y
  sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo usermod -a -G apache ec2-user
  sudo chown -R ec2-user:apache /var/www
  sudo chmod 2775 /var/www
  find /var/www -type d -exec sudo chmod 2775 {} \\;
  find /var/www -type f -exec sudo chmod 0664 {} \\;
  cd /var/www
  mkdir inc
  cd inc
  cat > dbinfo.inc << EOF
  <?php

  define('DB_SERVER', '${aws_db_instance.rds.endpoint}');
  define('DB_USERNAME', '${var.db_username}');
  define('DB_PASSWORD', '${var.db_password}');
  define('DB_DATABASE', 'dbwebserv');

  ?>
  EOF
  cd ..
  cd /var/www/html
  wget https://${local.s3_bucket_name}.s3.amazonaws.com/${aws_s3_object.website.id}
  EOT
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                 = "web_server_asg"
  launch_configuration = aws_launch_configuration.as_conf.id
  min_size             = 1
  max_size             = 3
  desired_capacity = 2
  vpc_zone_identifier = aws_subnet.Public_Sunnet[*].id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers, target_group_arns]
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  lb_target_group_arn = aws_lb_target_group.tgp.arn
}

