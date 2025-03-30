# Azure Infra Env - Terraform Module for Azure Virtual Network (VNET)

## Overview
The **azure-infra-env** repository offers a reusable **Terraform module** designed to deploy an **Azure Virtual Network (VNET)**. This module facilitates the creation of multiple environments in Azure, such as **Development** and **Production**, and supports the addition of resources like **Blob Storage**.

## Repository Structure

The repository is organized as follows:

- **modules/vnet**: Contains Terraform configurations for deploying the Azure Virtual Network.
- **environments**: Holds environment-specific configurations, allowing customization for different deployment scenarios.
- **.github/workflows**: Includes GitHub Actions workflows for Continuous Integration and Continuous Deployment (CI/CD).
- **README.md**: Provides this documentation.

## Prerequisites

- **Azure Account**: An active Azure account with sufficient permissions to create resources.

## Usage Guide

### 1. Clone the Repository
Begin by cloning the repository to your local machine:
```bash
git clone https://github.com/preferredintcom/azure-infra-env.git
cd azure-infra-env
```
# Terraform Azure Deployment Pipeline

This repository contains a GitHub Actions pipeline for automating the deployment of Terraform configurations to Azure across multiple environments (e.g., **dev** and **prod**). The pipeline ensures consistent infrastructure management and streamlined deployment.

## Overview

The pipeline automates the following tasks:

1. **Plan**: Initializes the Terraform configuration and generates an execution plan for the infrastructure.
2. **Deploy**: Applies the generated Terraform plan to Azure, creating or updating resources as defined.

The pipeline is triggered on every push to the `main` branch, allowing for automatic deployment of infrastructure changes.

## Trigger

This workflow is automatically triggered by a push to the `main` branch:

```yaml
on:
  push:
    branches: [main]
```

# Deploy Terraform with GitHub Actions

This GitHub Actions workflow automates the deployment of Terraform configurations to Azure environments.

## Workflow Overview

The workflow consists of two jobs:

1. **Plan** - Generates a Terraform execution plan for `dev` and `prod` environments.
2. **Deploy** - Applies the Terraform plan when changes are pushed to the `main` branch.

## Workflow Triggers

- The workflow runs on any push to the `main` branch.

## Permissions

- `contents: read` - Grants read access to the repository.

## Job Details

### Plan Job

This job:
- Checks out the repository.
- Sets up Terraform version.
- Logs in to Azure using credentials stored in GitHub Secrets.
- Initializes Terraform with the appropriate backend configuration.
- Generates a Terraform execution plan and uploads it as an artifact.

### Deploy Job

This job:
- Runs only on the `main` branch.
- Downloads the previously generated Terraform plan.
- Applies the Terraform configuration automatically without approval.

## Secrets Used

- `AZURE_CREDENTIALS` - Azure service principal credentials.
- `ARM_CLIENT_ID` - Azure client ID.
- `ARM_CLIENT_SECRET` - Azure client secret.
- `ARM_SUBSCRIPTION_ID` - Azure subscription ID.
- `ARM_TENANT_ID` - Azure tenant ID.

## Directory Structure

Terraform configurations should be stored under `./environments/{environment}` where `{environment}` is either `dev` or `prod`.

## Usage

1. Ensure your Terraform configurations are correctly placed.
2. Store necessary secrets in GitHub.
3. Push changes to the `main` branch to trigger the workflow.

## Troubleshooting

- Verify that required secrets are correctly configured.
- Check workflow logs for Terraform errors.
- Ensure correct backend configurations exist for each environment.

