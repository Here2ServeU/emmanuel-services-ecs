#!/bin/bash

# Set AWS Region
AWS_REGION="us-east-1"
VPC_ID="vpc-02110db7947ceb3f5"
SECURITY_GROUP="sg-07bdae1116f8a861c"

# ECR Repositories
ECR_REPO_FLASK="730335276920.dkr.ecr.${AWS_REGION}.amazonaws.com/flask-backend-ecr-repo"
ECR_REPO_NODE="730335276920.dkr.ecr.${AWS_REGION}.amazonaws.com/node-frontend-ecr-repo"

# ECS Cluster and Services
ECS_CLUSTER_NAME="emmanuel-app-cluster"
FLASK_TASK_NAME="flask-backend-task"
NODE_TASK_NAME="node-frontend-task"
FLASK_SERVICE_NAME="flask-backend-service"
NODE_SERVICE_NAME="node-frontend-service"

echo "Setting AWS Region to ${AWS_REGION}..."
export AWS_REGION=${AWS_REGION}

# Step 1: Delete ECS Services
echo "Deleting ECS Services..."
aws ecs update-service --cluster ${ECS_CLUSTER_NAME} --service ${FLASK_SERVICE_NAME} --desired-count 0 --region ${AWS_REGION}
aws ecs delete-service --cluster ${ECS_CLUSTER_NAME} --service ${FLASK_SERVICE_NAME} --force --region ${AWS_REGION}

aws ecs update-service --cluster ${ECS_CLUSTER_NAME} --service ${NODE_SERVICE_NAME} --desired-count 0 --region ${AWS_REGION}
aws ecs delete-service --cluster ${ECS_CLUSTER_NAME} --service ${NODE_SERVICE_NAME} --force --region ${AWS_REGION}

# Step 2: Delete ECS Cluster
echo "Deleting ECS Cluster..."
aws ecs delete-cluster --cluster ${ECS_CLUSTER_NAME} --region ${AWS_REGION}

# Step 3: Deregister Task Definitions
echo "Deregistering ECS Task Definitions..."
aws ecs deregister-task-definition --task-definition ${FLASK_TASK_NAME}:1 --region ${AWS_REGION}
aws ecs deregister-task-definition --task-definition ${NODE_TASK_NAME}:1 --region ${AWS_REGION}

# Step 4: Delete Load Balancers
echo "Deleting Load Balancers..."
FLASK_ALB_ARN=$(aws elbv2 describe-load-balancers --region ${AWS_REGION} --query "LoadBalancers[?contains(LoadBalancerName, 'flask-backend-alb')].LoadBalancerArn" --output text)
NODE_ALB_ARN=$(aws elbv2 describe-load-balancers --region ${AWS_REGION} --query "LoadBalancers[?contains(LoadBalancerName, 'node-frontend-alb')].LoadBalancerArn" --output text)

aws elbv2 delete-load-balancer --load-balancer-arn $FLASK_ALB_ARN --region ${AWS_REGION}
aws elbv2 delete-load-balancer --load-balancer-arn $NODE_ALB_ARN --region ${AWS_REGION}

# Step 5: Delete Target Groups
echo "Deleting Target Groups..."
FLASK_TG_ARN=$(aws elbv2 describe-target-groups --region ${AWS_REGION} --query "TargetGroups[?contains(TargetGroupName, 'flask-tg')].TargetGroupArn" --output text)
NODE_TG_ARN=$(aws elbv2 describe-target-groups --region ${AWS_REGION} --query "TargetGroups[?contains(TargetGroupName, 'node-tg')].TargetGroupArn" --output text)

aws elbv2 delete-target-group --target-group-arn $FLASK_TG_ARN --region ${AWS_REGION}
aws elbv2 delete-target-group --target-group-arn $NODE_TG_ARN --region ${AWS_REGION}

# Step 6: Delete ECR Repositories
echo "Deleting Amazon ECR Repositories..."
aws ecr delete-repository --repository-name flask-backend-ecr-repo --force --region ${AWS_REGION}
aws ecr delete-repository --repository-name node-frontend-ecr-repo --force --region ${AWS_REGION}

# Step 7: Verify Deletion
echo "Verifying AWS Resources Deletion..."

echo "Listing Remaining ECR Repositories..."
aws ecr describe-repositories --region ${AWS_REGION}

echo "Listing Remaining Load Balancers..."
aws elbv2 describe-load-balancers --region ${AWS_REGION}

echo "Listing Remaining ECS Clusters..."
aws ecs list-clusters --region ${AWS_REGION}

echo "AWS resources have been deleted successfully!"