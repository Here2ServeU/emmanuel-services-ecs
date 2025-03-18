#!/bin/bash

# Set AWS region
AWS_REGION="us-east-1"

# Set repository and image name
ECR_REPO_NAME="flask-backend-ecr-repo"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ECR_REPO_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME"

# Authenticate AWS CLI (Make sure you're logged in)
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URL

# Check if authentication was successful
if [ $? -ne 0 ]; then
    echo "AWS ECR login failed. Please check your AWS credentials."
    exit 1
fi

# Build the Docker image
docker build -t $ECR_REPO_NAME ../docker/backend

# Tag the image correctly
docker tag $ECR_REPO_NAME:latest $ECR_REPO_URL:latest

# Push the image to AWS ECR
docker push $ECR_REPO_URL:latest

# Output success message
echo "Docker image pushed to ECR: $ECR_REPO_URL:latest"