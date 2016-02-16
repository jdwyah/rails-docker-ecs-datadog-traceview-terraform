/* SSH key pair */
resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}


resource "aws_ecr_repository" "whatsize_ecr" {
  name = "whatsize_ecr"
}


/**
 * Autoscaling group.
 */
resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-asg"
  availability_zones   = ["${split(",", var.availability_zones)}"]
  launch_configuration = "${aws_launch_configuration.ecs-launch.name}"
  /* @todo - variablize */
  min_size             = 1
  max_size             = 10
  desired_capacity     = 3
}

/**
 * Launch configuration used by autoscaling group
 */
resource "aws_launch_configuration" "ecs-launch" {
  lifecycle {
    create_before_destroy = true
  }
  image_id             = "${lookup(var.amis, var.region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  security_groups      = ["${aws_security_group.ecs.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  user_data            = "${template_file.ecs_instance_user_data.rendered}"
}

/* ecs service cluster */
resource "aws_ecs_cluster" "default" {
  name = "${var.ecs_cluster_name}"
}

//ssh -vvv -i ~/.ssh/aws-eb.pem ec2-user@ec2-52-90-127-225.compute-1.amazonaws.com
