provider "aws" {
  region = "${var.region}"
}

resource "aws_cloudwatch_log_group" "magento_log_group" {
  name_prefix = "${var.logs_prefix}"
}

resource "aws_ecs_task_definition" "magento" {
  family                    = "magento"
  requires_compatibilities  = ["FARGATE"]
  task_role_arn             = "${var.task_role_arn}"
  execution_role_arn        = "${var.execution_role_arn}"
  network_mode              = "awsvpc"
  cpu                       = "${var.cpu}"
  memory                    = "${var.memory}"
  container_definitions = jsonencode([
    {
      name                    = "magento"
      image                   = "${var.magento_image}"
      portMappings            = [
        {
          hostPort = 80
          containerPort = 80
          protocol = "tcp"
        }
      ]
      logConfiguration: {
        logDriver = "awslogs"
        options = {
          awslogs-group = "${aws_cloudwatch_log_group.magento_log_group.name}"
          awslogs-region = "${var.region}"
          awslogs-stream-prefix = "${aws_cloudwatch_log_group.magento_log_group.name_prefix}"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "magento" {
  name                    = "magento-${var.environment}"
  cluster                 = "${var.cluster_id}"
  task_definition         = aws_ecs_task_definition.magento.arn
  desired_count           = 1
  launch_type             = "FARGATE"
  enable_execute_command  = true
  load_balancer {
    target_group_arn  = "${var.magento_tg_arn}"
    container_name    = "magento"
    container_port    = "80"
  }

  network_configuration {
    subnets = "${var.subnet_ids}"
    security_groups = "${var.security_group_ids}"
    assign_public_ip = true
  }
}


