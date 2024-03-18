#!/bin/bash

NAMESPACE=monitoring
RELEASE_NAME=prometheus-community
CLUSTER_NAME=mrolu-eks-Yo2vbr72  # add your cluster name here
# Check if the cluster is running and ready
status=$(aws eks describe-cluster --region us-east-1 --name $CLUSTER_NAME --query "cluster.status" --output text 2>/dev/null)

if [ "$status" = "ACTIVE" ]; then 
   echo " !!! Eks is Ready !!! "

   echo " Create Monitoring namespace "
   kubectl create namespace ${NAMESPACE} || true 

   echo " Deploy prometheus on eks "
   helm repo add ${RELEASE_NAME} https://prometheus-community.github.io/helm-charts
   helm repo update
   helm install prometheus ${RELEASE_NAME}/kube-prometheus-stack --namespace ${NAMESPACE} --set alertmanager.persistentVolume.storageClass="gp2" --set server.persistentVolume.storageClass="gp2"

   echo " Wait Pods to Start "
   sleep 2m

   echo " change prometheus service to NodePort "
   kubectl patch svc prometheus-kube-prometheus-prometheus -n ${NAMESPACE} -p '{"spec": {"type": "LoadBalancer"}}'
   kubectl patch svc prometheus-grafana -n ${NAMESPACE} -p '{"spec": {"type": "LoadBalancer"}}'
   echo "--------------------Creating External-IP--------------------"
   sleep 10s

   echo "--------------------Prometheus & Grafana  Ex-URL--------------------"
   kubectl get service prometheus-kube-prometheus-prometheus -n ${NAMESPACE} | awk '{print $4}'
   kubectl get service prometheus-grafana -n ${NAMESPACE} | awk '{print $4}'
   

else
   echo " Eks is not working "
fi
