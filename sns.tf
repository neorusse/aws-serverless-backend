resource "aws_sns_topic" "ecod" {
  name = var.name
}

resource "aws_sns_topic_policy" "ecod" {
  arn = aws_sns_topic.ecod.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
      "751837122948",
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam:751837122948:role/Lambda-DynamoDBStreams-SNS"]
    }

    resources = [
      aws_sns_topic.ecod.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_subscription" "ecod_downstream_subscribers" {
  topic_arn = aws_sns_topic.ecod.arn
  protocol  = "email"
  endpoint  = "ecod-orders-downstream@ecod.io"
}