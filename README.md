# Simple Web Application on Fargate

# Build Docker Image

To build the image locally run: `docker build -t simple-web-app .`

# Deploy VPC Network
```commandline
cd terraform-network
terraform init -backend-config=vars/dev/backend.hcl -reconfigure
terraform apply -var-file=vars/common.tfvars -var-file=vars/dev/vars.tfvars
```