provider "aws" {
  region = "${var.region}"
}

resource "aws_ecs_task_definition" "odoo" {
  family                    = "odoo"
  requires_compatibilities  = ["FARGATE"]
  task_role_arn             = "${var.task_role_arn}"
  execution_role_arn        = "${var.execution_role_arn}"
  network_mode              = "awsvpc"
  cpu                       = "${var.cpu}"
  memory                    = "${var.memory}"
  container_definitions = jsonencode([
    {
      name                    = "odoo"
      image                   = "${var.odoo-image}"
      memoryReservation       = "${var.memory_reservation}"
      portMappings            = [
        {
          hostPort = 8069
          containerPort = 8069
          protocol = "tcp"
        },
        {
          hostPort = 8071
          containerPort = 8071
          protocol = "tcp"
        },
        {
          hostPort = 8072
          containerPort = 8072
          protocol = "tcp"
        }
      ]
      environment             = [
        {
          name = "HOST"
          value = "${var.db_host}"
        },
        {
          name = "USER"
          value = "${var.db_user}"
        },
        {
          name = "PASSWORD"
          value = "${var.db_password}"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "odoo" {
  name                    = "odoo-${var.environment}"
  cluster                 = "${var.cluster_id}"
  task_definition         = aws_ecs_task_definition.odoo.arn
  desired_count           = 1
  launch_type             = "FARGATE"
  enable_execute_command  = true
  load_balancer {
    target_group_arn  = "${var.odoo_tg_arn}"
    container_name    = "odoo"
    container_port    = "8069"
  }

  network_configuration {
    subnets = "${var.subnet_ids}"
    security_groups = "${var.security_group_ids}"
    assign_public_ip = true
  }
}
