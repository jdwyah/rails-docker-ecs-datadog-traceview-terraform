
resource "template_file" "ecs_service_role_policy" {
  template = "policies/ecs-service-role-policy.json"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
  }
}

resource "template_file" "ecs_instance_user_data" {
  template = "scripts/ecs_instance_user_data.sh"
  vars {
    cluster_name = "${aws_ecs_cluster.default.name}"
    dd_task = "${aws_ecs_task_definition.datadog.family}"
  }
}



resource "template_file" "whatsize_task" {
  template = "tasks/whatsizeis.json"

  vars {
    secret_key_base = "${var.secret_key_base}"
    database_password = "${var.database_password}"
  }
}

resource "template_file" "datadog_task" {
  template = "tasks/datadog.json"
}
