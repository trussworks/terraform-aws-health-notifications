# DEPRECIATION NOTICE

This module has been deprecated and is no longer maintained. Should you need to continue to use it, please fork the repository. Thank you.

Creates an AWS Lambda function to send Slack notification for AWS health events (e.g.,outages).
using [truss-aws-tools](https://github.com/trussworks/truss-aws-tools).

Creates the following resources:

* IAM role for Lambda function
* CloudWatch Event to trigger when AWS sends health events.
* AWS Lambda function to capture AWS health events and sends the notifcation to Slack.

## Terraform Versions

Terraform 0.13. Pin module version to `~> 3.X`. Submit pull-requests to `master` branch.

Terraform 0.12. Pin module version to `~> 2.X`. Submit pull-requests to `terraform012` branch.


## Usage

```hcl
module "health-notifications" {
  source  = "trussworks/health-notifications/aws"
  version = "1.0.0"

  environment           = "prod"
  s3_bucket             = "lambda-builds-us-west-2"
  slack_channel         = "infra"
  ssm_slack_webhook_url = "slack-webhook-url"
  version_to_deploy     = "2.6"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_logs_retention_days"></a> [cloudwatch\_logs\_retention\_days](#input\_cloudwatch\_logs\_retention\_days) | Number of days to keep logs in AWS CloudWatch. | `string` | `90` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag, e.g prod. | `any` | n/a | yes |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | The name of the S3 bucket used to store the Lambda builds. | `string` | n/a | yes |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Slack channel to send alert to | `string` | n/a | yes |
| <a name="input_ssm_slack_webhook_url"></a> [ssm\_slack\_webhook\_url](#input\_ssm\_slack\_webhook\_url) | Name of the Slack webhook url parameter in Parameter Store. | `string` | n/a | yes |
| <a name="input_version_to_deploy"></a> [version\_to\_deploy](#input\_version\_to\_deploy) | The version the Lambda function to deploy. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
