# create the archive file from the “orders.py”, 
# this block of code creates an .zip file to send to AWS Lambda.
data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/lambda-logic/orders.py" 
  output_path = "orders.zip"
}

resource "aws_lambda_function" "ecod" {
  function_name = var.name
  filename      = "orders.zip"
  role          = aws_iam_role.lambda_functions_roles["Lambda-SQS-DynamoDB"].arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256

  runtime = "python3.9"
  timeout = 10

}

# Event source from SQS
# SQS ecod-queue that triggers our Lambda function
resource "aws_lambda_event_source_mapping" "sqs-lambda-trigger" {
  event_source_arn = "${aws_sqs_queue.ecod.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.ecod.arn}"
  batch_size       = 10
}

################
## Lambda 2
################

data "archive_file" "python_lambda_package_sns" {  
  type = "zip"  
  source_file = "${path.module}/lambda-logic/publish-sns.py" 
  output_path = "publish-sns.zip"
}

resource "aws_lambda_function" "ecod-lambda" {
  function_name = "${var.name}-sns-publish"
  filename      = "publish-sns.zip"
  role          = aws_iam_role.lambda_functions_roles["Lambda-DynamoDBStreams-SNS"].arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.python_lambda_package_sns.output_base64sha256

  runtime = "python3.9"
  timeout = 10

}

# An event source mapping so that lambda gets triggered when DynamoDB stream has data in it.
resource "aws_lambda_event_source_mapping" "ecod-lambda" {
  event_source_arn  = aws_dynamodb_table.ecod.stream_arn
  function_name     = aws_lambda_function.ecod-lambda.arn
  starting_position = "LATEST"
}