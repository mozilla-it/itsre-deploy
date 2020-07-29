## VPC module
This is a module that calls the [terraform registry vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0) module.
That being said it simplifies the calling of the registry module by doing the subnet cidr calculations for you. This module does assume that you
will only have a `private` and `public` subnet only
