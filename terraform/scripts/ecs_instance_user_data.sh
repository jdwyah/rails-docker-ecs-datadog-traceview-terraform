#!/bin/bash
DD_API_KEY=f35a1ed0e3a9acf18cfe0d0ab127e745 bash -c \"$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)\"
cluster="${cluster_name}"
task_def="${dd_task}"
echo ECS_CLUSTER=$cluster >> /etc/ecs/ecs.config
start ecs
yum install -y aws-cli jq
instance_arn=$(curl -s http://localhost:51678/v1/metadata \
  | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $NF}' )
az=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
region=$${az:0:$${#az} - 1}
echo "
cluster=$cluster
az=$az
region=$region
aws ecs start-task --cluster $cluster --task-definition $task_def \
  --container-instances $instance_arn --region $region" >> /etc/rc.local
echo "finished"
