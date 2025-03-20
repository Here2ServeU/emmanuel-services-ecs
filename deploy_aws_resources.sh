#!/bin/bash

# Set AWS Region
AWS_REGION="us-east-1"
VPC_ID="vpc-02110db7947ceb3f5"
SUBNETS=("subnet-05cb29a9a04e93491" "subnet-07af10aa454f0b1a5" "subnet-0fd1861f670e2f8a6")
SECURITY_GROUP="sg-07bdae1116f8a861c"

# ECR Repositories
ECR_REPO_FLASK="730335276920.dkr.ecr.${AWS_REGION}.amazonaws.com/flask-backend-ecr-repo"
ECR_REPO_NODE="730335276920.dkr.ecr.${AWS_REGION}.amazonaws.com/node-frontend-ecr-repo"

# ECS Cluster and Services
ECS_CLUSTER_NAME="emmanuel-app-cluster"
FLASK_TASK_NAME="flask-backend-task"
NODE_TASK_NAME="node-frontend-task"
FLASK_CONTAINER_PORT=5050
NODE_CONTAINER_PORT=8080

echo "Setting AWS Region to ${AWS_REGION}..."
export AWS_REGION=${AWS_REGION}

# Step 1: Create Amazon ECR Repositories
echo "Creating Amazon ECR Repositories..."
aws ecr create-repository --repository-name flask-backend-ecr-repo --region ${AWS_REGION}
aws ecr create-repository --repository-name node-frontend-ecr-repo --region ${AWS_REGION}

# Step 2: Authenticate Docker with AWS ECR
echo "Authenticating Docker with AWS ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin 730335276920.dkr.ecr.${AWS_REGION}.amazonaws.com

# Step 3: Build, Tag & Push Docker Images
echo "Building and Pushing Docker Images..."

# Flask Backend
docker build -t flask-backend:latest ./docker/backend
docker tag flask-backend:latest ${ECR_REPO_FLASK}:latest
docker push ${ECR_REPO_FLASK}:latest

# Node Frontend
docker build -t node-frontend:latest ./docker/frontend
docker tag node-frontend:latest ${ECR_REPO_NODE}:latest
docker push ${ECR_REPO_NODE}:latest

# Step 4: Create Load Balancers
echo "Creating Load Balancers..."

FLASK_ALB_ARN=$(aws elbv2 create-load-balancer --name flask-backend-alb --type application \
    --subnets ${SUBNETS[@]} --security-groups ${SECURITY_GROUP} --region ${AWS_REGION} \
    --query 'LoadBalancers[0].LoadBalancerArn' --output text)

NODE_ALB_ARN=$(aws elbv2 create-load-balancer --name node-frontend-alb --type application \
    --subnets ${SUBNETS[@]} --security-groups ${SECURITY_GROUP} --region ${AWS_REGION} \
    --query 'LoadBalancers[0].LoadBalancerArn' --output text)

echo "Flask Backend ALB: $FLASK_ALB_ARN"
echo "Node Frontend ALB: $NODE_ALB_ARN"

# Step 5: Create Target Groups
echo "Creating Target Groups..."

FLASK_TG_ARN=$(aws elbv2 create-target-group --name flask-tg --protocol HTTP --port ${FLASK_CONTAINER_PORT} \
    --vpc-id ${VPC_ID} --target-type ip --region ${AWS_REGION} --query 'TargetGroups[0].TargetGroupArn' --output text)

NODE_TG_ARN=$(aws elbv2 create-target-group --name node-tg --protocol HTTP --port ${NODE_CONTAINER_PORT} \
    --vpc-id ${VPC_ID} --target-type ip --region ${AWS_REGION} --query 'TargetGroups[0].TargetGroupArn' --output text)

echo "Flask Target Group ARN: $FLASK_TG_ARN"
echo "Node Target Group ARN: $NODE_TG_ARN"

# Step 6: Create ECS Cluster
echo "Creating ECS Cluster..."
aws ecs create-cluster --cluster-name ${ECS_CLUSTER_NAME} --region ${AWS_REGION}

# Step 7: Register Task Definitions
echo "Registering ECS Task Definitions..."

# Flask Backend Task Definition
aws ecs register-task-definition --family ${FLASK_TASK_NAME} \
    --network-mode awsvpc --requires-compatibilities FARGATE \
    --execution-role-arn arn:aws:iam::730335276920:role/emmanuel-app-task-execution-role \
    --cpu "512" --memory "1024" --region ${AWS_REGION} \
    --container-definitions "[{
        \"name\": \"${FLASK_TASK_NAME}\",
        \"image\": \"${ECR_REPO_FLASK}:latest\",
        \"essential\": true,
        \"portMappings\": [{ \"containerPort\": ${FLASK_CONTAINER_PORT}, \"hostPort\": ${FLASK_CONTAINER_PORT} }]
    }]"

# Node Frontend Task Definition
aws ecs register-task-definition --family ${NODE_TASK_NAME} \
    --network-mode awsvpc --requires-compatibilities FARGATE \
    --execution-role-arn arn:aws:iam::730335276920:role/emmanuel-app-task-execution-role \
    --cpu "512" --memory "1024" --region ${AWS_REGION} \
    --container-definitions "[{
        \"name\": \"${NODE_TASK_NAME}\",
        \"image\": \"${ECR_REPO_NODE}:latest\",
        \"essential\": true,
        \"portMappings\": [{ \"containerPort\": ${NODE_CONTAINER_PORT}, \"hostPort\": ${NODE_CONTAINER_PORT} }]
    }]"

# Step 8: Create ECS Services
echo "Creating ECS Services..."

aws ecs create-service --cluster ${ECS_CLUSTER_NAME} --service-name flask-backend-service \
    --task-definition ${FLASK_TASK_NAME} --desired-count 1 --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=${SUBNETS[@]},securityGroups=[${SECURITY_GROUP}],assignPublicIp=\"ENABLED\"}" \
    --load-balancers "targetGroupArn=${FLASK_TG_ARN},containerName=${FLASK_TASK_NAME},containerPort=${FLASK_CONTAINER_PORT}" \
    --region ${AWS_REGION}

aws ecs create-service --cluster ${ECS_CLUSTER_NAME} --service-name node-frontend-service \
    --task-definition ${NODE_TASK_NAME} --desired-count 1 --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=${SUBNETS[@]},securityGroups=[${SECURITY_GROUP}],assignPublicIp=\"ENABLED\"}" \
    --load-balancers "targetGroupArn=${NODE_TG_ARN},containerName=${NODE_TASK_NAME},containerPort=${NODE_CONTAINER_PORT}" \
    --region ${AWS_REGION}

# Step 9: Verify Resources
echo "Verifying AWS Resources..."

echo "Listing ECR Repositories..."
aws ecr describe-repositories --region ${AWS_REGION}

echo "Listing Load Balancers..."
aws elbv2 describe-load-balancers --region ${AWS_REGION}

echo "Listing ECS Clusters..."
aws ecs list-clusters --region ${AWS_REGION}

echo "Listing ECS Services..."
aws ecs list-services --cluster ${ECS_CLUSTER_NAME} --region ${AWS_REGION}

echo "AWS resources have been set up successfully!"