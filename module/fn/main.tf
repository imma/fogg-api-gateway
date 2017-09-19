variable "function_name" {}
variable "function_arn" {}

variable "function_version" {
  default = ""
}

variable "unique_prefix" {}
variable "source_arn" {}

variable "fn_rc" {
  default = "$LATEST"
}

variable "fn_live" {
  default = "$LATEST"
}

resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = "${var.function_arn}"
  function_version = "${coalesce(var.function_version,var.fn_live)}"
}

resource "aws_lambda_alias" "rc" {
  name             = "rc"
  function_name    = "${var.function_arn}"
  function_version = "${var.fn_rc}"
}

resource "aws_lambda_permission" "live" {
  statement_id  = "${var.unique_prefix}-${var.function_name}"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${var.function_name}"
  source_arn    = "${var.source_arn}"
  qualifier     = "${aws_lambda_alias.live.name}"
}

resource "aws_lambda_permission" "rc" {
  statement_id  = "${var.unique_prefix}-${var.function_name}"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${var.function_name}"
  source_arn    = "${var.source_arn}"
  qualifier     = "${aws_lambda_alias.rc.name}"
}

output "live_arn" {
  value = "${aws_lambda_alias.live.arn}"
}

output "rc_arn" {
  value = "${aws_lambda_alias.rc.arn}"
}
