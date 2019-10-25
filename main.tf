/**
 * Creates an AWS Lambda function to send Slack notification for AWS health events (e.g.,outages).
 * using [truss-aws-tools](https://github.com/trussworks/truss-aws-tools).
 *
 * Creates the following resources:
 *
 * * IAM role for Lambda function
 * * CloudWatch Event to trigger when AWS sends health events.
 * * AWS Lambda function to capture AWS health events and sends the notifcation to Slack.
 *
 * ## Usage
 *
 * ```hcl
 * module "health-notifications" {
 *   source  = "trussworks/health-notifications/aws"
 *   version = "1.0.0"
 *
 *   environment           = "prod"
 *   s3_bucket             = "lambda-builds-us-west-2"
 *   slack_channel         = "infra"
 *   ssm_slack_webhook_url = "slack-webhook-url"
 *   version_to_deploy     = "2.6"
 * }
 * ```
 */

locals {
  pkg  = "truss-aws-tools"
  name = "aws-health-notifier"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

#
# IAM
#

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "main" {
  # Allow creating and writing CloudWatch logs for Lambda function.
  statement {
    sid = "WriteCloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.name}-${var.environment}:*"]
  }

  statement {
    sid = "SSMAllowRead"

    effect = "Allow"

    actions = [
      "ssm:GetParameter",
    ]

    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.ssm_slack_webhook_url}"]
  }
}

resource "aws_iam_role" "main" {
  name               = "lambda-${local.name}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy" "main" {
  name = "lambda-${local.name}-${var.environment}"
  role = "${aws_iam_role.main.id}"

  policy = "${data.aws_iam_policy_document.main.json}"
}

#
# CloudWatch Event
#

resource "aws_cloudwatch_event_rule" "main" {
  name          = "${local.name}-${var.environment}"
  description   = "AWS Health Notifications"
  event_pattern = "${file("${path.module}/event-pattern.json")}"
}

resource "aws_cloudwatch_event_target" "main" {
  rule = "${aws_cloudwatch_event_rule.main.name}"
  arn  = "${aws_lambda_function.main.arn}"
}

#
# CloudWatch Logs
#

resource "aws_cloudwatch_log_group" "main" {
  # This name must match the lambda function name and should not be changed
  name              = "/aws/lambda/${local.name}-${var.environment}"
  retention_in_days = "${var.cloudwatch_logs_retention_days}"

  tags = {
    Name        = "${local.name}-${var.environment}"
    Environment = "${var.environment}"
  }
}

#
# Lambda Function
#

resource "aws_lambda_function" "main" {
  depends_on = ["aws_cloudwatch_log_group.main"]

  s3_bucket = "${var.s3_bucket}"
  s3_key    = "${local.pkg}/${var.version_to_deploy}/${local.pkg}.zip"

  function_name = "${local.name}-${var.environment}"
  role          = "${aws_iam_role.main.arn}"
  handler       = "${local.name}"
  runtime       = "go1.x"
  memory_size   = "128"
  timeout       = "60"

  environment {
    variables = {
      SLACK_CHANNEL         = "${var.slack_channel}"
      SLACK_EMOJI           = ":thisisfine:"
      SSM_SLACK_WEBHOOK_URL = "${var.ssm_slack_webhook_url}"
    }
  }

  tags = {
    Name        = "${local.name}-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_lambda_permission" "main" {
  statement_id = "${local.name}-${var.environment}"

  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.main.function_name}"

  principal  = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.main.arn}"
}
