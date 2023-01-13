resource "aws_sqs_queue" "ecod" {
  name                      = var.name
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600 # 4 day
  receive_wait_time_seconds = 10
  sqs_managed_sse_enabled   = true

  tags = {
    Name = var.name
  }
}

resource "aws_sqs_queue_policy" "ecod" {
  queue_url = aws_sqs_queue.ecod.id

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": : {
        "AWS": "751837122948"
      },
      "Action": [
        "SQS:*"
      ],
      "Resource": "${aws_sqs_queue.ecod.arn}",
    },
    {
      "Sid": "__sender_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam:751837122948:role/APIGateway-SQS"
        ]
      },
      "Action": [
        "SQS:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.ecod.arn}"
    },
    {
      "Sid": "__receiver_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam:751837122948:role/Lambda-SQS-DynamoDB"
        ]
      },
      "Action": [
        "SQS:ChangeMessageVisibility",
        "SQS:DeleteMessage",
        "SQS:ReceiveMessage"
      ],
      "Resource": "${aws_sqs_queue.ecod.arn}"
    }
  ]
}
POLICY
}