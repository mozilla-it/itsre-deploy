variable "region" {
  default = "us-west-2"
}

variable "enabled" {}

variable "stack_name" {
  default = "OIDCIdentityProvider"
}

variable "template_url" {
  default = "https://s3-us-west-2.amazonaws.com/public.us-west-2.infosec.mozilla.org/oidc-identity-provider/5f48b78c87d98c18b55c98a6e5c285a80d53424c/oidc_identity_provider.5f48b78c87d98c18b55c98a6e5c285a80d53424c.yml"
}

variable "template_parameters" {
  type = map(string)
  default = {
    Url            = "https://auth.mozilla.auth0.com/"
    ClientIDList   = "N7lULzWtfVUDGymwDs0yDEq6ZcwmFazj" #pragma: allowlist secret
    ThumbprintList = "7ccc2a87e3949f20572b18482980505fa90cac3b,02faf3e291435468607857694df5e45b68851868,2b8f1b57330dbba2d07a6c51f70ee90ddab9ad8e"
  }
}
