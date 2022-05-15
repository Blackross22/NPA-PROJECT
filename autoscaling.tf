##################################################################################
# RESOURCES
##################################################################################

resource "aws_launch_configuration" "as_conf" {
  name_prefix =  "web_server"
  image_id      = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.allow_ssh_web.id]

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

