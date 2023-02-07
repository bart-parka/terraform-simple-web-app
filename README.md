# Simple Web Application on Fargate

This repository can be used to deploy a very simple web application built in Python, using Flask. It is deployed on AWS Fargate.

## Build Docker Image

From within `./app`:

1. `make all` to build, tag and push image to ECR
2. `make run` to run image locally for testing

## Deploy VPC Network
```commandline
cd terraform-network
terraform init -backend-config=vars/dev/backend.hcl -reconfigure
terraform apply -var-file=vars/common.tfvars -var-file=vars/dev/vars.tfvars
```

## Deploy Application
```commandline
cd terraform-app
terraform init -backend-config=vars/dev/backend.hcl -reconfigure
terraform apply -var-file=vars/common.tfvars -var-file=vars/dev/vars.tfvars
```

## Architecture

![alt text](/architecture.png?raw=true)

The above architecture provides:
* High-Availability: resources are replicated across multiple availability zones and have no single points of failure
* Resiliency: tasks automatically recover/rebuild in event of failure
* Easy Scalability: easy integration with CloudWatch alarms and auto-scaling

Disadvantages:
* Fargate offers minimal overhead in terms of operational support, however as it is a type of managed service it will always be a little more expensive to run when compared to EKS/EC2 Launch Type
* K8s is more prevalent and would require re-engineering

## Improvements to "Productionise"

### Web Application
1. Use HTTPS for encryption and verification of traffic
2. Use Content Delivery Network (CDN) like Amazon CloudFront, to cache static content
3. Use a Web Application Firewall (WAF) as layer 7 (application) defense (SQL Injections, XSS etc.)
4. Ensure no vulnerabilities are built into the application (more on that below)
5. Add Scaling rules such that the application scales with demand
6. Segregate environments (dev,int,preprod etc.) into dedicated AWS accounts
7. Flask app using built in development server, need to deploy following to productionise:
   1. Dedicated HTTP server (Gunicorn)
   2. Reverse proxy (NGINX)
8. For a more complex application, split to microservices:
   1. Serve static website content from S3 for example
   2. Cache data to speed up the UI
   3. Move business logic to backend
9. Add proper logging utility (CloudWatch, DataDog, Prometheus etc.)
10. Add proper monitoring (pre-determined data) utility (Dashboards etc.)
11. Add proper observability (aggregate data) utility (Status Checks page for individual microservices etc.)
12. Multi-region deployment for disaster recovery fail-over
13. Multi-cloud deployment for disaster recovery fail-over

### CI/CD Pipeline
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
6. Avoid using long-lived credentials - use AWS IAM and session tokens.
7. Define and implement promotion process between environments + branching strategy, for example:
   1. Developer raises a pull-request from feature branch to develop/main branch
   2. Container build kicks off and, provided all tests pass an image is pushed to registry in Tooling
   3. Status of build is posted back to PR, and the transient image can be pulled down for further analysis/testing
   4. Reviewer checks the PR and merges
   5. Image is versioned and deployed to QA/Integration environment where it is tested with any other changes
   6. Once the criteria for promotion is passed, Image is pushed up to Pre-Prod/Production environments
8. Blue-green deployment/Canary deployment in production