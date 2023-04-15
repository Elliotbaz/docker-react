#!/bin/bash

set -e

# Set AWS credentials using environment variables
export AWS_ACCESS_KEY_ID="AKIAQT3NMMEK7RUG5B5Q"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION=us-east-1

# Authenticate Docker to AWS ECR
eval $(aws ecr get-login --no-include-email)

# Build and push Docker image to ECR
docker build -t my-eb-app .
docker tag my-eb-app:latest 042642202901.dkr.ecr.us-east-1.amazonaws.com/my-eb-app:latest
docker push 042642202901.dkr.ecr.us-east-1.amazonaws.com/my-eb-app:latest

# Deploy to Elastic Beanstalk
version_label="$(date +'%Y%m%d%H%M%S')"
aws elasticbeanstalk create-application-version --application-name my-eb-app --version-label $version_label --source-bundle S3Bucket="elasticbeanstalk-us-east-1-042642202901",S3Key="docker"
aws elasticbeanstalk update-environment --application-name my-eb-app --environment-name Dockerreact-env --version-label $version_label
