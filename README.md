<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates an AWS Lambda function to send Slack notification for AWS health events (e.g.,outages).
using [truss-aws-tools](https://github.com/trussworks/truss-aws-tools).

Creates the following resources:

* IAM role for Lambda function
* CloudWatch Event to trigger when AWS sends health events.
* AWS Lambda function to capture AWS health events and sends the notifcation to Slack.

## Usage

```hcl
module "aws_health_notifications" {
  source = "../../modules/aws-aws-health-notifications"

  environment           = "prod"
  s3_bucket             = "lambda-builds-us-west-2"
  slack_channel         = "infra"
  ssm_slack_webhook_url = "slack-webhook-url"
  version_to_deploy     = "2.6"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudwatch\_logs\_retention\_days | Number of days to keep logs in AWS CloudWatch. | string | `"90"` | no |
| environment | Environment tag, e.g prod. | string | n/a | yes |
| s3\_bucket | The name of the S3 bucket used to store the Lambda builds. | string | n/a | yes |
| slack\_channel | Slack channel to send alert to | string | n/a | yes |
| ssm\_slack\_webhook\_url | Name of the Slack webhook url parameter in Parameter Store. | string | n/a | yes |
| version\_to\_deploy | The version the Lambda function to deploy. | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
