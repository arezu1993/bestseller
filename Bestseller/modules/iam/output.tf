output "iam_role_arn" {
  value = aws_iam_role.s3_role.arn
}

output "iam_role_name" {
  value = aws_iam_role.s3_role.name
}

output "iam_policy_arn" {
  value = aws_iam_policy.s3_access_policy.arn
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.my_instance_profile.name
}