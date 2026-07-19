# AWS Lambda EC2 Auto Scheduler using Terraform

## Real-World Production Problem Statement

Company XYZ has two EC2 instances used by developers for testing and QA
activities.

These instances are required only during business hours, but they
continue running 24x7, including nights and weekends. As a result, the
company pays for compute resources even when no one is using them.

The Cloud Engineering team has been asked to automate this process so
that:

-   EC2 instances automatically stop every **Friday at 8:00 PM IST**
-   EC2 instances automatically start every **Monday at 8:00 AM IST**
-   No manual intervention is required
-   The solution is reliable, repeatable, and managed as Infrastructure
    as Code (IaC)

------------------------------------------------------------------------

# Proposed Solution

To solve this problem, we will build a fully automated serverless
Solution using AWS services and Terraform.

## Architecture

  <img width="900" height="900" alt="image" src="https://github.com/user-attachments/assets/7ebbd71b-1b75-4016-a3fb-33f20f87a270" />


## Technologies Used

-   Terraform
-   AWS Lambda
-   Python 3.12
-   Boto3 (AWS SDK for Python)
-   Amazon EventBridge
-   IAM Roles & Policies
-   Amazon EC2
-   CloudWatch Logs

------------------------------------------------------------------------

# Solution Workflow

1.  Terraform provisions all AWS resources.
2.  EventBridge runs on a predefined schedule.
3.  EventBridge invokes the AWS Lambda function.
4.  Lambda reads the requested action (`start` or `stop`).
5.  Using Boto3, Lambda calls the EC2 API.
6.  The specified EC2 instances are started or stopped automatically.
7.  CloudWatch Logs capture every execution for monitoring and
    troubleshooting.

------------------------------------------------------------------------

# Business Benefits

-   Reduce AWS infrastructure costs
-   Eliminate repetitive manual work
-   Improve operational efficiency
-   Use a serverless architecture with minimal maintenance
-   Manage infrastructure through Terraform
-   Follow Infrastructure as Code best practices

------------------------------------------------------------------------

# Expected Outcome

At the end of this project, the EC2 instances will automatically stop
every Friday evening and start again every Monday morning, helping
reduce unnecessary AWS costs while requiring zero manual effort.

**Commands:**

terraform init -backend-config=backend.config

terraform plan -var-file=dev.tfvars

terraform apply -var-file=dev.tfvars -auto-approve

terraform destroy -var-file=dev.tfvars -auto-approve


