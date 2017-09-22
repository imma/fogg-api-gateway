variable "api_name" {}
variable "rest_api_id" {}
variable "resource_id" {}

variable "http_method" {
  default = "POST"
}

variable "invoke_arn" {}

resource "aws_api_gateway_resource" "fn" {
  rest_api_id = "${var.rest_api_id}"
  parent_id   = "${var.resource_id}"
  path_part   = "${var.api_name}"
}

resource "aws_api_gateway_method" "fn" {
  rest_api_id   = "${var.rest_api_id}"
  resource_id   = "${aws_api_gateway_resource.fn.id}"
  http_method   = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "fn" {
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${aws_api_gateway_resource.fn.id}"
  http_method             = "${aws_api_gateway_method.fn.http_method}"
  uri                     = "${replace(var.invoke_arn,"/invocations",":$${stageVariables.alias}/invocations")}"
  integration_http_method = "${aws_api_gateway_method.fn.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  content_handling        = "CONVERT_TO_TEXT"
}

output "resource" {
  value = "${aws_api_gateway_integration.fn.resource_id}"
}
