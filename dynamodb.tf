variable "name" {}

resource "aws_dynamodb_table" "ecod" {
  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "orderId"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "orderId"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "OrderTitleIndex"
    hash_key           = "OrderTitle"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = var.name
  }
}