#!/bin/bash
# deploy_docker_registry.sh

# Set AWS account ID and region
ACCOUNTID="532739883212"   
REGION="us-east-1"

# AWS ECR login
echo "Logging in to AWS ECR..."
if ! aws ecr get-login-password --region "${REGION}" | docker login --username AWS --password-stdin "${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com"; then
    echo "Error: Failed to log in to AWS ECR. Please check your AWS credentials and try again."
    exit 1
fi
echo "Successfully logged in to AWS ECR."

# Check if Kubernetes namespace exists
NAMESPACE="emart"   # change appropriately
echo "Checking if Kubernetes namespace ${NAMESPACE} exists..."
if kubectl get namespace "${NAMESPACE}" &>/dev/null; then
    echo "Namespace ${NAMESPACE} already exists. Skipping namespace creation."
else
    # Create Kubernetes namespace
    echo "Creating Kubernetes namespace: ${NAMESPACE}"
    if ! kubectl create namespace "${NAMESPACE}"; then
        echo "Error: Failed to create namespace ${NAMESPACE}. Please check your Kubernetes configuration."
        exit 1
    fi
    echo "Namespace ${NAMESPACE} created successfully."
fi

# Check if Kubernetes secret exists
SECRET_NAME="ecr-registry-secret"
echo "Checking if Kubernetes secret ${SECRET_NAME} exists in namespace ${NAMESPACE}..."
if kubectl get secret "${SECRET_NAME}" -n "${NAMESPACE}" &>/dev/null; then
    echo "Secret ${SECRET_NAME} already exists in namespace ${NAMESPACE}. Skipping secret creation."
else
    # Create Kubernetes secret for ECR registry
    echo "Creating Kubernetes secret ${SECRET_NAME} for ECR registry..."
    if ! kubectl create secret generic "${SECRET_NAME}" \
        --from-file=.dockerconfigjson="${HOME}/.docker/config.json" \
        --type=kubernetes.io/dockerconfigjson --namespace "${NAMESPACE}"; then
        echo "Error: Failed to create Kubernetes secret ${SECRET_NAME}. Please check your Docker configuration and try again."
        exit 1
    fi
    echo "Kubernetes secret ${SECRET_NAME} created successfully."
fi

# Display available secrets in the namespace
echo "Available secrets in namespace ${NAMESPACE}:"
kubectl get secrets -n "${NAMESPACE}"
