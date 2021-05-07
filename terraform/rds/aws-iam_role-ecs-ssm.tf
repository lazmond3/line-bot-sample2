resource "aws_iam_role_policy" "mysql_db_password_policy_secretsmanager" {
  name = "password-policy-mysql_db_password_policy_secretsmanager"
  role = var.ecs_task_execution_role_id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_secretsmanager_secret.database_password_secret.arn}"
        ]
      }
    ]
  }
  EOF
}
