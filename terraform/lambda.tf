data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../lambda"
  output_path = "./lambda_function_payload.zip"
}

resource "random_integer" "lambda_name" {
  min = 1000
  max = 10000
}

resource "aws_lambda_function" "form_handler" {
  filename      = "lambda_function_payload.zip"
  function_name = "form_handler_${random_integer.lambda_name.result}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"
  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.waitlist_table.name
    }
  }
}

resource "aws_lambda_function_url" "form_handler" {
  function_name      = aws_lambda_function.form_handler.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["https://${var.domain_name}"]
    allow_methods = ["POST"]
  }
}

output "form_handler_url" {
  value = aws_lambda_function_url.form_handler.function_url
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "dynamodb_handler_access" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = [
          aws_dynamodb_table.waitlist_table.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda-policy-attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodb_handler_access.arn
}
