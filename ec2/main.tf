provider "aws" {
  region = var.region
}



resource "aws_launch_template" "launchtp" {
  name_prefix = "deveqi"
  image_id = var.ami_id
  instance_type = var.instance-type
  key_name = aws_key_pair.key.key_name
  user_data = filebase64("ec2-setup.sh")



  monitoring {
    enabled = true
  }

  network_interfaces {
     associate_public_ip_address = true
     delete_on_termination = true
     #security_groups = [ aws ]
  }
}