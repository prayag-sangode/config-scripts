provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-uat-vpc"
  }
}

# Subnet in us-east-1a
resource "aws_subnet" "my_subnet_1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my-uat-subnet-1a"
  }
}

# Subnet in us-east-1b
resource "aws_subnet" "my_subnet_1b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "my-uat-subnet-1b"
  }
}

# S3 bucket
resource "aws_s3_bucket" "my_uat_test_bucket" {
  bucket = "my-uat-test-bucket"

  tags = {
    Name        = "my-uat-test-bucket"
    Environment = "UAT"
  }
}

# Enable bucket versioning (required for S3 Files FS)
resource "aws_s3_bucket_versioning" "my_uat_test_bucket_versioning" {
  bucket = aws_s3_bucket.my_uat_test_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# IAM role for S3 Files
resource "aws_iam_role" "s3files_role" {
  name = "S3FilesRole_my_uat"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "elasticfilesystem.amazonaws.com"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Inline IAM policy for S3 Files role
resource "aws_iam_role_policy" "s3files_inline_policy" {
  name = "S3FilesInlinePolicy"
  role = aws_iam_role.s3files_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.my_uat_test_bucket.arn,
          "${aws_s3_bucket.my_uat_test_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Security group for NFS traffic
resource "aws_security_group" "s3fs_sg" {
  name        = "s3fs-mount-sg"
  description = "Allow NFS traffic for S3 Files FS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # restrict to your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# S3 Files File System
resource "aws_s3files_file_system" "my_test_fs" {
  bucket   = aws_s3_bucket.my_uat_test_bucket.arn
  role_arn = aws_iam_role.s3files_role.arn

  accept_bucket_warning = true

  tags = {
    Name        = "my-uat-s3fs"
    Environment = "UAT"
  }

  depends_on = [aws_s3_bucket_versioning.my_uat_test_bucket_versioning]
}

# Mount targets
resource "aws_s3files_mount_target" "mt_1a" {
  file_system_id = aws_s3files_file_system.my_test_fs.id
  subnet_id      = aws_subnet.my_subnet_1a.id
  security_groups = [aws_security_group.s3fs_sg.id]
}

resource "aws_s3files_mount_target" "mt_1b" {
  file_system_id = aws_s3files_file_system.my_test_fs.id
  subnet_id      = aws_subnet.my_subnet_1b.id
  security_groups = [aws_security_group.s3fs_sg.id]
}

# Current account ID for trust policy
data "aws_caller_identity" "current" {}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.my_uat_test_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.my_uat_test_bucket.arn
}

output "s3files_role_arn" {
  value = aws_iam_role.s3files_role.arn
}

output "s3files_fs_id" {
  value = aws_s3files_file_system.my_test_fs.id
}

output "s3files_fs_arn" {
  value = aws_s3files_file_system.my_test_fs.arn
}

output "s3files_fs_status" {
  value = aws_s3files_file_system.my_test_fs.status
}

output "mount_target_1a_id" {
  value = aws_s3files_mount_target.mt_1a.id
}

output "mount_target_1b_id" {
  value = aws_s3files_mount_target.mt_1b.id
}
