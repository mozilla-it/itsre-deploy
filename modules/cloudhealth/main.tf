module "cloudhealth" {
  source      = "github.com/CloudHealth/terraform-cloudhealth-iam//role?ref=master"
  role-name   = "${var.cloudhealth_role_name}"
  external-id = "${var.cloudhealth_external_id}"
}
