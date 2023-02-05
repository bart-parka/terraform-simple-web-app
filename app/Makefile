.DEFAULT_GOAL := help
AWS_REGION = eu-west-2
ECR_IMAGE_NAME = simple-web-app

.PHONY: all
all: build tag push

.PHONY: help
help: ## Show this!
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build a latest version of the container image
	@printf "Building new version of image...\n"
	docker build -t ${ECR_IMAGE_NAME} .
	@printf "Build complete "
	@${MAKE} tick

.PHONY: tag
tag: ## Tag the latest version of the container image ready to push to ECR
	@printf "Fetching the AWS account number...\n"
	$(eval AWS_ACCOUNT_NUMBER=$(shell aws sts get-caller-identity --query "Account" --output text))
	@printf "Account number: ${AWS_ACCOUNT_NUMBER} "
	@${MAKE} tick
	@printf "Tagging new image...\n"
	docker tag ${ECR_IMAGE_NAME}:latest ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_IMAGE_NAME}:latest
	@printf "Tagging complete "
	@${MAKE} tick

.PHONY: push
push: ## Push the latest version of the container image to ECR
	@printf "Fetching the AWS account number...\n"
	$(eval AWS_ACCOUNT_NUMBER=$(shell aws sts get-caller-identity --query "Account" --output text))
	@printf "Account number: ${AWS_ACCOUNT_NUMBER} "
	@${MAKE} tick
	@printf "Logging into ECR...\n"
	@aws ecr get-login-password --region ${AWS_REGION} | docker login --password-stdin --username AWS "$(AWS_ACCOUNT_NUMBER).dkr.ecr.${AWS_REGION}.amazonaws.com"
	@printf "Pushing image version: ${VERSION} and latest...\n"
	docker push ${AWS_ACCOUNT_NUMBER}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_IMAGE_NAME}:latest
	@printf "Push complete "
	@${MAKE} tick

.PHONY: run
run: ## Run the application locally
	docker run -p 8081:8081 -d -e PORT=8081 ${ECR_IMAGE_NAME}
	@${MAKE} tick

.PHONY: tick
tick:
	@printf "\033[36m\xE2\x9C\x94\033[0m \n"
