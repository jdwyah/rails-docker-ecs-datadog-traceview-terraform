


variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "availability_zones" {
  description = "The availability zones"
  default = "us-east-1b,us-east-1c,us-east-1d"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "my-ecs-cluster"
}

variable "s3_bucket_name" {
  description = "The name of the s3 bucket to store the registry data in."
  default = "s3-ecs-docker-registry.example.com"
}



/* ECS optimized AMIs per region */
variable "amis" {
  default = {
    us-east-1      = "ami-cb2305a1"
    us-west-1      = "ami-bdafdbdd"
    us-west-2      = "ami-ec75908c"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "The aws ssh key name."
  default = "aws-eb"
}

variable "key_file" {
  description = "The ssh public key for using with the cloud provider."
  default = "/Users/jeffdwyer/.ssh/aws-eb.pub"
}

variable "secret_key_base" {
  description = "The rails secret_key_base"
}

variable "database_password" {
  description = "db password"
}
