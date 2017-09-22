variable "rest_api_id" {}
variable "stage_name" {}
variable "domain_name" {}

resource "aws_api_gateway_deployment" "stage" {
  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"

  variables {
    alias = "${var.stage_name}"
  }
}

resource "aws_api_gateway_base_path_mapping" "stage" {
  depends_on  = ["aws_api_gateway_deployment.stage"]
  api_id      = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
  domain_name = "${var.domain_name}"
  base_path   = "${var.stage_name}"
}

resource "aws_api_gateway_method_settings" "stage" {
  rest_api_id = "${var.rest_api_id}"
  stage_name  = "${var.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }
}