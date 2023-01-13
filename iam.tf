variable "iam_roles" {
  type = map
}

resource "aws_iam_policy" "Lambda-Write-DynamoDB" {

  name     = "Lambda-Write-DynamoDB"
  path        = "/"

  description = "Lambda write to DynamoDB policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
                "dynamodb:PutItem",
                "dynamodb:DescribeTable"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "Lambda-SNS-Publish" {

  name     = "Lambda-SNS-Publish"
  path        = "/"

  description = "Lambda write to DynamoDB policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
                "sns:Publish",
                "sns:GetTopicAttributes",
                    "sns:ListTopics"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "Lambda-DynamoDBStreams-Read" {

  name     = "Lambda-DynamoDBStreams-Read"
  path        = "/"

  description = "Lambda read DynamoDB Streams policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeStream",
                "dynamodb:ListStreams",
                "dynamodb:GetRecords"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "Lambda-Read-SQS" {

  name     = "Lambda-Read-SQS"
  path        = "/"

  description = "Lambda read SQS policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
                "sqs:DeleteMessage",
                "sqs:ReceiveMessage",
                "sqs:GetQueueAttributes",
                "sqs:ChangeMessageVisibility"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_functions_roles" {
  
  for_each = var.iam_roles

  name = each.value.name

  path = each.value.path

  description = each.value.description

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ${each.value.service}
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "cloudWatchFullAccess" {
  role       = aws_iam_role.lambda_functions_roles["Lambda-SQS-DynamoDB"].name
  policy_arn = aws_iam_policy.Lambda-Write-DynamoDB.arn
}

resource "aws_iam_role_policy_attachment" "cloudWatchFullAccess" {
  role       = aws_iam_role.lambda_functions_roles["Lambda-SQS-DynamoDB"].name
  policy_arn = aws_iam_policy.Lambda-Read-SQS.arn
}

resource "aws_iam_role_policy_attachment" "cloudWatchFullAccess" {
  role       = aws_iam_role.lambda_functions_roles["Lambda-DynamoDBStreams-SNS"].name
  policy_arn = aws_iam_policy.Lambda-DynamoDBStreams-Read.arn
}

resource "aws_iam_role_policy_attachment" "cloudWatchFullAccess" {
  role       = aws_iam_role.lambda_functions_roles["Lambda-DynamoDBStreams-SNS"].name
  policy_arn = aws_iam_policy.Lambda-SNS-Publish.arn
}

data "aws_iam_policy" "AmazonAPIGatewayPushToCloudWatchLogs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "cloudWatchFullAccess" {
  role       = aws_iam_role.lambda_functions_roles["APIGateway-SQS"].name
  policy_arn = data.aws_iam_policy.AmazonAPIGatewayPushToCloudWatchLogs.arn
}