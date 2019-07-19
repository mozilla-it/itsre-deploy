# itcloud-deploy

This repository helps creating new AWS accounts automatizing several common actions for Mozilla IT.

It uses Terraform code structured in a modular way where one can choose which components to create. Originally the code was part of nubisproject/nubis-deploy but was later adapted to suit our current needs.

This is the list of components it will (conditionaly) create:

* Roles and users for IT SRE members using federated login.
* A a new VPC with configurable components.
* An AWS account alias and password policy.
* Enable and configure CloudTrail.
* Allow Cloudhealth to fetch billing data.
* Create a new DNS zone with the name of the account under mozit.cloud.

