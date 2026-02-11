#!/usr/bin/env bash

# If anything fails, stop the pipeline
set -euo pipefail

# Start minikube if it isn't already running
minikube start

# Apply deployment and service manifests
kubectl apply -f rolling-update-deployment.yaml
kubectl apply -f rolling-update-service.yaml

# Check initial deployment state 
kubectl get deployments
kubectl get pods -o wide

# Check that service is accessible
minikube service nginx-application-service --url

# Trigger rolling update to new nginx version
kubectl set image deployment/rolling-app-dep nginx-app=nginx:1.26

# Check rollout status
kubectl rollout status deployment/rolling-app-dep

# Confirm rollout is complete
kubectl get pods -o wide

# Rolling back deployment
kubectl rollout undo deployment/rolling-app-dep

# Confirm rollback was successful
kubectl rollout status deployment/rolling-app-dep
kubectl get pods -o wide