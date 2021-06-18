provider "aws" {
  region = "${var.region}"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs-cluster-name}-${var.environment}"
}
