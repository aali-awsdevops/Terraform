resource "aws_launch_template" "ops360" {

  # instance_type is a required field so we need a default value.
  # t3.medium is the default value when creating a node group in the AWS Console, use that.
  name = "${var.ops360_env}"
  instance_type = var.node_instance_type
  key_name = var.keypair

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.ops360_env}"
    }
  }

   block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 80
      volume_type = "gp3"
    }
  }

}

resource "aws_launch_template" "alpha" {

  # instance_type is a required field so we need a default value.
  # t3.medium is the default value when creating a node group in the AWS Console, use that.
  name = "${var.alpha_env}"
  instance_type = var.node_instance_type
  key_name = var.keypair

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.alpha_env}"
    }
  }

   block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 80
      volume_type = "gp3"
    }
  }

}
