aws = {
  account_id = "908153604820"
  region     = "us-east-1"
}

name = "ecod-orders"

lambda_functions_roles = {
  Lambda-SQS-DynamoDB = {
    name = "Lambda-SQS-DynamoDB"
    path = "/"
    description = "Allows Lambda functions to talk to SQS and DynamoDB"
    service = "lambda.amazonaws.com"
  },
  Lambda-DynamoDBStreams-SNS = {
    name = "Lambda-DynamoDBStreams-SNS"
    path = "/"
    description = "Allows Lambda functions to be triggered using DynamoDB Stream"
    service = "lambda.amazonaws.com"
  }
  APIGateway-SQS = {
    name = "APIGateway-SQS"
    path = "/"
    description = "Allow APIGateway to send HTTP POST to SQS"
    service = "apigateway.amazonaws.com"
  },
}