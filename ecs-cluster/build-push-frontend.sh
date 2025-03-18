#!/bin/bash

# Set variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO_NAME="angular-frontend-ecr-repo"
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO_NAME"

# Authenticate Docker with AWS ECR
echo "Logging into Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI

# Check if ECR repository exists
echo "Checking if ECR repository exists..."
REPO_CHECK=$(aws ecr describe-repositories --repository-names $ECR_REPO_NAME --region $AWS_REGION 2>&1)

if [[ $? -ne 0 ]]; then
  echo "Repository $ECR_REPO_NAME not found. Creating it..."
  aws ecr create-repository --repository-name $ECR_REPO_NAME --region $AWS_REGION
fi

# Ensure the frontend directory exists
FRONTEND_DIR="../docker/frontend"
if [ ! -d "$FRONTEND_DIR" ]; then
  echo "Error: Directory '$FRONTEND_DIR' not found."
  exit 1
fi

# Navigate to the frontend directory
cd $FRONTEND_DIR

# Build the Angular frontend Docker image
echo "Building the Angular frontend Docker image..."
docker buildx build --platform linux/amd64 -t $ECR_URI:latest .

# Verify build success
if [ $? -ne 0 ]; then
  echo "Error: Docker build failed."
  exit 1
fi

# Tag the image correctly
echo "Tagging the image for AWS ECR..."
docker tag $ECR_URI:latest $ECR_URI:latest

# Push image to AWS ECR
echo "Pushing the image to Amazon ECR..."
docker push $ECR_URI:latest

# Verify push success
if [ $? -ne 0 ]; then
  echo "Error: Docker push failed."
  exit 1
fi

# Display success message
echo "✅ Docker image successfully pushed to: $ECR_URI:latest"