/* ELB for the app */
resource "aws_elb" "whatsize-elb" {
  name = "whatsize-elb"
  availability_zones = [
    "${split(",", var.availability_zones)}"]

  listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  /* @todo - handle SSL */
  /*listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }*/

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:5000/"
    interval = 30
  }

  connection_draining = false

  tags {
    Name = "whatsize-elb"
  }
}

/* container and task definitions for running the actual Docker  */
resource "aws_ecs_service" "whatsize-service" {
  name = "whatsize-service"
  cluster = "${aws_ecs_cluster.default.id}"
  task_definition = "${aws_ecs_task_definition.whatsize.arn}"
  desired_count = 3
  iam_role = "${aws_iam_role.ecs_role.arn}"
  depends_on = [
    "aws_iam_role_policy.ecs_service_role_policy"]

  load_balancer {
    elb_name = "${aws_elb.whatsize-elb.id}"
    container_name = "whatsize"
    container_port = 3000
  }
}

resource "aws_ecs_task_definition" "whatsize" {
  family = "whatsize"
  container_definitions = "${template_file.whatsize_task.rendered}"
}

resource "aws_ecs_task_definition" "datadog" {
  family = "dd-agent-task"
  container_definitions = "${template_file.datadog_task.rendered}"

  volume = {
    name = "docker_sock"
    host_path = "/var/run/docker.sock"
  }
  volume = {
    name = "proc"
    host_path = "/proc/"
  }
  volume = {
    name = "cgroup"
    host_path = "/cgroup/"
  }
}
