variable "function_name" {}
variable "unique_prefix" {}
variable "source_arn" {}
variable "role" {}
variable "deployment_zip" {}
variable "fn_arn" {}

variable "fn_dev" {
  default = "$LATEST"
}

variable "fn_prod" {
  default = "$LATEST"
}

resource "aws_lambda_alias" "prod" {
  name             = "prod"
  function_name    = "${var.fn_arn}"
  function_version = "${var.fn_prod}"
}

resource "aws_lambda_alias" "dev" {
  name             = "dev"
  function_name    = "${var.fn_arn}"
  function_version = "${var.fn_dev}"
}

resource "aws_lambda_permission" "prod" {
  statement_id  = "${var.unique_prefix}-${var.function_name}"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${aws_lambda_alias.fn.name}"
  source_arn    = "${var.source_arn}"
  qualifier     = "${aws_lambda_alias.prod.name}"
}

resource "aws_lambda_permission" "dev" {
  statement_id  = "${var.unique_prefix}-${var.function_name}"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${aws_lambda_alias.fn.name}"
  source_arn    = "${var.source_arn}"
  qualifier     = "${aws_lambda_alias.dev.name}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.fn.invoke_arn}"
}
