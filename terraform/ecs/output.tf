output "ecs-id" {
  value = aws_ecs_service.main.id
}
output ecs_task_execution_role_id {
  value = aws_iam_role.ecs_task_execution_role.id
  type = string
}
