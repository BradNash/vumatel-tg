# Vumatel Terragrunt Documentation

## Introduction

Terraform is an open-source infrastructure as code (IaC) tool that allows users to define and provision infrastructure using a high-level configuration language. It enables consistent, repeatable, and automated infrastructure deployments. [Learn more about Terraform here](https://www.terraform.io/).

### Terraform Modules

Terraform Modules are reusable configurations that help organize infrastructure code efficiently. They allow developers to encapsulate reusable components and improve the maintainability of infrastructure as code. Modules can be published, shared, and versioned to ensure consistency across multiple deployments.

### Terragrunt

Terragrunt is a thin wrapper for Terraform that provides extra features for managing multiple Terraform modules, including:
- DRY (Don't Repeat Yourself) principles with shared configurations
- Automation for remote state management
- Dependency handling between Terraform modules

[Learn more about Terragrunt here](https://terragrunt.gruntwork.io/).

## AWS Account Setup

When setting up AWS SSO, ensure that the account names are correctly configured as follows:

| AWS Account Name                 | Account ID        |
|----------------------------------|------------------|
| vumatel-b2c                      | 339712841843    |
| vumatel-bc2-preprod              | 992382552351    |
| vumatel-central                  | 800117417621    |
| vumatel-data                     | 466876547045    |
| vumatel-integration              | 211125628455    |
| vumatel-integration-preprod      | 637423199642    |
| vumatel-operations               | 866644257938    |
| vumatel-preprod                  | 039129132867    |
| vumatel-prod                     | 774405590946    |
| vumatel-transit                  | 483107167038    |

## Prerequisites

### AWS & SSO Setup
- Follow [AWS SSO documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/)

### Terraform Installation
- Download and install Terraform following the [official guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Terragrunt Installation
- Download and install Terragrunt following the [official guide](https://terragrunt.gruntwork.io/docs/getting-started/install/)

## Team Responsibilities

### Role-Based Access
- If you are working on a B2C AWS account, your access and code will be limited to that account.
- The same applies to all other AWS accounts.

### Platform Department
- This team is responsible for:
    - Security configurations
    - Permissions management
    - Networking services
- All security, networking, and permission-related use cases must be routed through the platform team.

## Repository Setup

### Directory Structure
```plaintext
vumatel-terragrunt ------------------------------------------------------------------ (Git root)
    terraform-modules --------------------------------------------------------------- (Modular Terraform modules)
    terragrunt ---------------------------------------------------------------------- (Terragrunt root)
        b2c ------------------------------------------------------------------------- (Department-based infrastructure)
            _envcommon -------------------------------------------------------------- (Common HCL configurations)
                compute ------------------------------------------------------------- (Services grouped by Aws Service Categories)
                database
                ecs
                network
                    alb.hcl ---------------------------------------------------------- (Common hcl file for the service)
                    api-gateway.hcl
                storage
            accounts ----------------------------------------------------------------- (Account-based infrastructure)
                vumatel-b2c
                    __global --------------------------------------------------------- (Global services like Route53, S3 - Not required)
                    af-south-1 ------------------------------------------------------- (Region-based infrastructure)
                        prod --------------------------------------------------------- (Production-specific infrastructure)
                            compute
                            data
                            database
                            ecs
                            network -------------------------------------------------- (Services grouped by Aws Service Categories)
                                cloudfront
                                    ssa-assets --------------------------------------- (Main hcl directory)
                                        terragrunt.hcl ------------------------------- (Main hcl configuration file)
                            environment.hcl ------------------------------------------ (Environment variables)
                        shared ------------------------------------------------------- (Shared services for multiple environments)
                        region.hcl --------------------------------------------------- (Regional variables)
                    account.hcl ------------------------------------------------------ (Account configurations)
            terragrunt.hcl ----------------------------------------------------------- (Terragrunt configuration for B2C department)
        integration
        platform
        vumaconnect
```

## Repository Breakdown
- **`terraform-modules`**: Houses modular Terraform modules.
- **`terragrunt`**: Root directory for Terragrunt configurations.
- **`b2c`**: Departmental infrastructure breakdown.
- **`_envcommon`**: Shared configurations across all environments.
- **`accounts`**: Infrastructure breakdown per AWS account.
- **`af-south-1`**: Infrastructure breakdown per region.
- **`environment.hcl`**: Stores common variables per environment.
- **`region.hcl`**: Stores common variables per region.
- **`account.hcl`**: Stores common variables per account.

## Terragrunt Breakdown

Refer to the [Terragrunt documentation](https://terragrunt.gruntwork.io/).

Example (Main): `vumatel-terragrunt/terragrunt/b2c/accounts/vumatel-b2c/af-south-1/prod/network/cloudfront/ssa-assets/terragrunt.hcl`

```hcl
include "root" {
  path = find_in_parent_folders()
}
```
- Includes the root configuration.

```hcl
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/cloudfront.hcl"
  expose = true
}
```
- References the common Terragrunt configuration.

```hcl
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
}
```
- Loads environment, account, and region-specific variables.

```hcl
terraform {
  source = include.envcommon.locals.base_source_url
}
```
- Specifies the Terraform module source.

```hcl
inputs = {
  name = "vumatel-ssa-assets"
}
```
- Defines service-specific inputs.
- It is important that all services have the `name` variable, even if not specified in the module/variables.tf files directly. This is in connection to the `context.tf`, which I will touch on in the Terraform modules.

Example (__envcommon): `vumatel-terragrunt/terragrunt/b2c/terragrunt.hcl`

- **Important notes**:
    - ```hcl 
        locals {} 
        ```
      This pulls in the common vars.
    - ```hcl 
        context = {
          namespace      = "b2c" ---------------------------------------------- (Namespace for department)
          environment    = local.environment_vars.locals.environment ---------- (Environment for department)
          delimiter      = "-" ------------------------------------------------ (Symbol to seperate names)
          label_key_case = "lower" -------------------------------------------- (Casing for all names)
          enabled        = true ----------------------------------------------- (Deufalt enable all modules)
          label_order    = ["name", "environment"] ---------------------------- (Labeling structure eg. alb-prod)
          tags = {}      ------------------------------------------------------ (Default tags for all services)
        } 
      ```
      This variable is important for tagging and naming conventions within the service. This will be referenced in the terraform-modules, where we include a default context.tf file.
    - ```hcl 
       generate "provider" {}
      ```
      This section provides a short description for generating the provider configuration.
    - ```hcl 
       remote_state {}
      ```
      All remote state files live in S3 in the vumatel-operations - 866644257938 account.
      - ```hcl 
        inputs = merge(
          local.context,
          local.account_vars.locals,
          local.region_vars.locals,
          local.environment_vars.locals
        )
        ```
        This performs a default merge ontop of all other inputs.

## Terraform Modules

Refer to the [Terraform module documentation](https://developer.hashicorp.com/terraform/language/modules/syntax).

### Repository setup
```plaintext
terraform-modules ------------------------------------------------------------- (Terraform root)
    modules ------------------------------------------------------------------- (Modules broken down per provider)
        cloudposse 
            terraform-aws-api-gateway ----------------------------------------- (Clone of CloudPosse repo, in case custom code is needed)
                custom.tf ----------------------------------------------------- (Contains custom modifications to CloudPosse repo)
        vumatel
            terraform-aws-template -------------------------------------------- (Custom module template)
                context.tf ---------------------------------------------------- (Ensures consistent tagging & naming)
                main.tf
                outputs.tf
                variables.tf
                versions.tf
```

## IMPORTANT

- **Avoid specific use-case modules**: Ensure that modules are generic and reusable. It is crucial to design modules that are flexible, scalable, and do not tie them to specific use cases. This is vital for long-term maintainability and scalability.
- **Future Plans**: The `terraform-modules` directory will be moved to a separate repository for better versioning, tagging, and control.
- **`context.tf` is crucial**: It ensures standard naming conventions and tagging best practices.
    - `module.this.id` for the naming of the service and not the `var.name`.
    - `module.this.tags` for the tagging of the service and not the `var.tags`.
    - This file also includes a `local.enabled` variable to enable or disable specific modules if necessary.
    - All modules going forward should have and utilize this `context.tf` file.
- **Use modular design principles**: Follow DRY principles and avoid hardcoding configurations.
- When naming global recources (s3, be aware of aws naming restrictions)

---

## Links in Document

- [Terraform Official Documentation](https://www.terraform.io/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [AWS SSO Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/)
- [Terraform AWS Get Started Install Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terragrunt Install Guide](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [CloudPosse Labeling](https://github.com/cloudposse/terraform-aws-utils/blob/main/context.tf)
- [Terraform Module Syntax Documentation](https://developer.hashicorp.com/terraform/language/modules/syntax)
