variable "function_name" {}
variable "unique_prefix" {}
variable "source_arn" {}
variable "role" {}
variable "deployment_zip" {}

resource "aws_lambda_function" "fn" {
  filename         = "${var.deployment_zip}"
  function_name    = "${var.function_name}"
  role             = "${var.role}"
  handler          = "app.app"
  runtime          = "python3.6"
  source_code_hash = "${base64sha256(file("${var.deployment_zip}"))}"
  publish          = true
}

resource "aws_lambda_alias" "prod" {
  name             = "prod"
  function_name    = "${aws_lambda_function.fn.function_name}"
  function_version = "$LATEST"
}

resource "aws_lambda_permission" "fn" {
  statement_id  = "${var.unique_prefix}-${var.function_name}"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${aws_lambda_alias.fn.name}"
  source_arn    = "${var.source_arn}"
  qualifier     = "${aws_lambda_alias.prod.name}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.fn.invoke_arn}"
}
