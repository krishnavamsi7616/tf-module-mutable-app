resource "aws_iam_policy" "allow-secret-manager-read-access" {
  name        = "RoboShop-${var.COMPONENT}-SecretManager-ReadAccess-${var.ENV}"
  path        = "/"
  description = "RoboShop-${var.COMPONENT}-SecretManager-ReadAccess-${var.ENV}"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": "arn:aws:secretsmanager:us-east-1:794750663080:secret:roboshop/all-L9IPtu"
      },
      {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "allow-secret-manager-read-access" {
  name = "RoboShop-${var.COMPONENT}-SecretManager-ReadAccess-${var.ENV}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "RoboShop-${var.COMPONENT}-SecretManager-ReadAccess-${var.ENV}"
  }
}

resource "aws_iam_role_policy_attachment" "attach-policy" {
  role      = aws_iam_role.allow-secret-manager-read-access.name
  policy_arn = aws_iam_policy.allow-secret-manager-read-access.arn
}

resource "aws_iam_instance_profile" "allow-secret-manager-read-access" {
  name = "RoboShop-${var.COMPONENT}-SecretManager-ReadAccess-${var.ENV}"
  role = aws_iam_role.allow-secret-manager-read-access.name
}
