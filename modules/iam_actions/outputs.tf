locals {
  iam_code_artifact_read_packages = [
    "codeartifact:DescribePackageVersion",
    "codeartifact:DescribeRepository",
    "codeartifact:GetPackageVersionReadme",
    "codeartifact:GetRepositoryEndpoint",
    "codeartifact:ListPackages",
    "codeartifact:ListPackageVersions",
    "codeartifact:ListPackageVersionAssets",
    "codeartifact:ListPackageVersionDependencies",
    "codeartifact:ReadFromRepository"
  ]
}


output "iam_actions" {
  description = "iam action permission sets"
  value = {
    iam_ssm_get_parameter_actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    iam_secretsmanager_read_actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetResourcePolicy",
    ]

    iam_secretsmanager_list_actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    iam_secretsmanager_put_actions = [
      "secretsmanager:PutSecretValue",
    ]

    iam_secretsmanager_get_put_actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:PutSecretValue",
      "secretsmanager:GetResourcePolicy",
    ]

    iam_secretsmanager_delete_actions = [
      "secretsmanager:DeleteSecret"
    ]

    iam_ssm_get_put_parameter_actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:PutParameter",
    ]

    iam_s3_list_bucket_actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:GetBucketLocation",
    ]

    iam_s3_read_only_actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectTagging",
    ]

    iam_s3_put_actions = [
      "s3:AbortMultipartUpload",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:ListBucketMultipartUploads"
    ]

    iam_s3_delete_actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
    ]

    iam_s3_delete_version_actions = [
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
    ]

    iam_s3_read_write_actions = [
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:GetObjectTagging",
      "s3:GetObjectVersionTagging",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
    ]

    iam_s3_read_write_no_delete_actions = [
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectVersion",
      "s3:GetObjectTagging",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
    ]


    iam_kms_encrypt_decrypt_actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]

    iam_kms_decrypt_actions = [
      "kms:DescribeKey",
      "kms:Decrypt",
    ]

    iam_kms_encrypt_actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
    ]

    iam_sqs_read_actions = [
      "sqs:Get*",
      "sqs:List*",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage*",
      "sqs:ChangeMessageVisibility",
    ]

    iam_sqs_read_write_actions = [
      "sqs:Get*",
      "sqs:List*",
      "sqs:ReceiveMessage",
      "sqs:SendMessage*",
      "sqs:DeleteMessage*",
      "sqs:ChangeMessageVisibility",
    ]

    iam_sqs_write_actions = [
      "sqs:Get*",
      "sqs:List*",
      "sqs:SendMessage*",
    ]

    iam_dynamodb_read_only_access = [
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:Query",
    ]

    iam_dynamodb_query_access = [
      "dynamodb:DescribeTable",
      "dynamodb:Query"
    ]

    iam_dynamodb_get_put_update_access = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:Query",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
    ]

    iam_dynamodb_read_write_access = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:Query",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
    ]

    iam_dynamodb_full_read_write_access = [
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
    ]

    iam_dynamodb_update_item_access = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
    ]

    iam_ecr_get_authorisation_token = [
      "ecr:GetAuthorizationToken",
    ]

    iam_ecr_pull_images = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]

    iam_ecr_pull_push_images = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]

    iam_code_artifact_read_packages = local.iam_code_artifact_read_packages

    iam_code_artifact_read_write_packages = concat(
      local.iam_code_artifact_read_packages,
      [
        "codeartifact:PublishPackageVersion"
      ]
    )

    iam_sns_publish_access = [
      "sns:Publish"
    ]

    iam_lambda_invoke_function = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration"
    ]
  }
}
