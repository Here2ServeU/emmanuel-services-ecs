#!/bin/bash

AWS_REGION="us-east-1"
ECR_REPO="730335276920.dkr.ecr.${AWS_REGION}.amazonaws.com/node-frontend-ecr-repo"

echo "Logging into Amazon ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}

echo "Checking if ECR repository exists..."
aws ecr describe-repositories --repository-name node-frontend-ecr-repo --region ${AWS_REGION} >/dev/null 2>&1 || \
aws ecr create-repository --repository-name node-frontend-ecr-repo --region ${AWS_REGION}

echo "Building the Node.js frontend Docker image..."
docker build -t node-frontend:latest ../docker/frontend

echo "Tagging the image..."
docker tag node-frontend:latest ${ECR_REPO}:latest

echo "Pushing the image to Amazon ECR..."
docker push ${ECR_REPO}:latest

echo "Node.js Frontend Docker image successfully built and pushed!"
