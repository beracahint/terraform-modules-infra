output "ecs_role_id" {
  value = aws_iam_role.ecs_role.id
}

output "ecs_role_arn" {
  value = aws_iam_role.ecs_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_odoo_task_role_arn" {
  value = aws_iam_role.ecs_odoo_task_role.arn
}