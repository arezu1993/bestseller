# IAM policy granting permissions to interact with any S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Policy allowing interaction with any S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          # You can add more actions as needed
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM role
resource "aws_iam_role" "s3_role" {
  name               = "s3-access-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Define IAM instance profile
resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-instance-profile"
  role = aws_iam_role.s3_role.name  # Associate IAM role with instance profile
}
