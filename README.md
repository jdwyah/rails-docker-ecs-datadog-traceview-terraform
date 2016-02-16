# rails-docker-ecs-datadog-traceview-terraform

See http://blog.jdwyah.com/2016/02/ruby-on-rails-on-docker-on-amazon-ecs-w.html for explanation.

This is a terraform framework to get your
- [ECS Cluster] (https://aws.amazon.com/ecs/)
- ECR Repo
- ELB
- VPC
- Roles
- Rails App
- DataDog
- Traceview

All running.

To run:

1) Put your aws creds in a tfvars file.

2) Replace the DataDog & Traceview keys since I was lazy and didn't variableize them.

3) Run
```
terraform plan var-file="~/.whatsize.tfvars"
terraform apply var-file="~/.whatsize.tfvars"
```

4) Find your ECR repo in AWS and push some Docker image there
