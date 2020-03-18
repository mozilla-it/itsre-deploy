

resource "aws_cloudformation_stack" "maws_idp" {
  count = var.enabled ? 1 : 0

  name = var.stack_name

  capabilities = [
    "CAPABILITY_IAM"
  ]

  template_url = var.template_url

  parameters = var.template_parameters

  tags = {
    Name      = "maws-idp"
    Region    = var.region
    Terraform = "true"
  }
}
