# Simple Web Application on Fargate

# Build Docker Image

To build the image locally run: `docker build -t simple-web-app .`

# Deploy VPC Network
```commandline
cd terraform-network
terraform init -backend-config=vars/dev/backend.hcl -reconfigure
terraform apply -var-file=vars/common.tfvars -var-file=vars/dev/vars.tfvars
```

# Architecture

![alt text](/architecture.png?raw=true)

HA
DR
Resiliency
Easy scalability

# Improvements to "Productionise"

## Web Application

1. HTTPS
2. CDN
3. WAF
4. Vulnerabilities on the image
5. Add scaling Rules
6. Segregate environments into dedicated AWS accounts
7. Add proper logging utility, using CloudWatch or dedicated tooling
8. Add Logging/Monitoring + Observability tooling
9. For complex applications, you could split to microservices/serve static website content from S3
10. Multi-region deployment for disaster recovery fail-over
11. Multi-cloud deployment for disaster recovery fail-over

## CI/CD Pipelines
1. Include Security features on the pipeline:
   1. Template scanning before Infrastructure deployment (e.g. Checkov)
   2. Static-Analysis of code (e.g. SonarQube) before container image push to ECR
2. Add automated tests to the application (using e.g. PyTest for Python), for example:
   1. Unit Tests
   2. Functional Tests
   3. API Tests
3. Centralise Pipelines Logs to chosen Logging utility
4. Dockerised "Agents" for running different steps
5. Separate Tooling AWS account for Artifacts, GitHub Runners/Agents
6. Define and implement promotion process between environments + branching strategy, for example:
   1. Developer raises a pull-request from feature branch to develop/main branch
   2. Container build kicks off and, provided all tests pass an image is pushed to registry in Tooling
   3. Status of build is posted back to PR, and the transient image can be pulled down for further analysis/testing
   4. Reviewer checks the PR and merges
   5. Image is versioned and deployed to QA/Integration environment where it is tested with any other changes
   6. Once the criteria for promotion is passed, Image is pushed up to Pre-Prod/Production environments
7. Blue-green deployment/Canary deployment in production