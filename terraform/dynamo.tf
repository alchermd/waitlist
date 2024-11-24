resource "random_integer" "dynamodb_table_name" {
  min = 1000
  max = 10000
}

resource "aws_dynamodb_table" "waitlist_table" {
  name         = "WaitlistTable${random_integer.dynamodb_table_name.result}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Email"

  attribute {
    name = "Email"
    type = "S"
  }
}
