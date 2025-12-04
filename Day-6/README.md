# Day 6 - File Structure

## Overview

On Day 6 of the 30-Day AWS Terraform Challenge, the focus is on File Structure. This includes defining providers, variables, outputs, and leveraging local values for better configuration management.

## Files in the Directory

- **backend.tf**: Configures the Terraform backend to store the state file.
- **locals.tf**: Defines local values for reusable configurations.
- **main.tf**: Contains the main resource definitions for AWS infrastructure.
- **outputs.tf**: Specifies the outputs to display after applying the configuration.
- **provider.tf**: Configures the AWS provider.
- **terraform.tfvars**: Contains variable values for the configuration.
- **variables.tf**: Declares the variables used in the configuration.

## How to Use

1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the changes:
   ```bash
   terraform plan
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```
4. View the outputs:
   ```bash
   terraform output
   ```

## Notes

- Ensure AWS credentials are configured before running Terraform commands.
- Use `.gitignore` to exclude sensitive files like `.terraform/` and `terraform.tfstate` from version control.

## Next Steps

- Continue refining the configuration for Day 7.
- Explore advanced Terraform features like modules and workspaces.
