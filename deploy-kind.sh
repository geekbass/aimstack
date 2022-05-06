#!/usr/bin/env bash
set -e

# Define variables so these can be modified for future use
CLUSTER_NAME="aimstack"

# Check for Docker install
if [[ `which docker` == "" ]]; then
  echo "Docker not found. Please install docker before moving on."
  exit 1
fi

# Check for kubectl install
if [[ `which kubectl` == "" ]]; then
  echo "Kubectl not found. Please install kubectl before moving on."
  echo "https://kubernetes.io/docs/tasks/tools/install-kubectl/"
  exit 1
fi

# If kind is not installed then exit
if [[ `which kind` == "" ]]; then
  echo "Kind not found. Please install kind before moving on."
  echo "https://kind.sigs.k8s.io/docs/user/quick-start"
  exit 1
fi

# If kustomize is not installed then exit
if [[ `which kustomize` == "" ]]; then
  echo "Kustomize not found. Please install kustomize before moving on."
  exit 1
fi

# Check for existing kind cluster with same name
if [[ `kind get clusters | grep ${CLUSTER_NAME}` == "" ]]; then
  echo "Creating K8s locally with kind..."
  # If data exists from previous delete it first.
  rm -rf data
  mkdir -pv data
  kind create cluster --config kind.yaml --name ${CLUSTER_NAME}
  # Apply the context to kubectl
  kubectl cluster-info --context kind-${CLUSTER_NAME}

  # Sleep for 5 secs. Hack for giving enough time for control plane components to start.
  sleep 10

  # Wait for K8s services to start
  kubectl wait --namespace kube-system --for=condition=ready pod --selector=component=etcd --timeout=130s
  kubectl wait --namespace kube-system --for=condition=ready pod --selector=component=kube-scheduler --timeout=130s
  kubectl wait --namespace kube-system --for=condition=ready pod --selector=component=kube-apiserver --timeout=130s
  kubectl wait --namespace kube-system --for=condition=ready pod --selector=component=kube-controller-manager --timeout=130s

  echo "###########################################################"
  echo "Creating Aimstack namespace..."
  kubectl create ns aimstack
  sleep 3


  # Deploy Argo CD
  echo "###########################################################"
  echo "Building the Aimstack image..."
  docker build -t aimstack:0.0.1 .
  sleep 3

  # Load the image to Kind cluster
  echo "###########################################################"
  echo "Loading Docker image to cluster..."
  kind load docker-image aimstack:0.0.1 --name ${CLUSTER_NAME}
  sleep 3

  # Deploy Aimstack
  echo "###########################################################"
  echo "Deploying Aimstack UI and Server..."
  kustomize build . | kubectl apply -f-

  # Done
  echo "###########################################################"
  echo "DONE..."
  echo "Use Port-Forward method for Kind so we don't tie to Ingress..."
  echo ""
  echo "Example for Server:"
  echo "kubectl port-forward -n aimstack svc/aimstack 53800:53800"
  echo ""
  echo "Example for UI:"
  echo "kubectl port-forward -n aimstack svc/aimstack 8080:80"
else
  echo "kind cluster with cluster name ${CLUSTER_NAME} already exists..."
  echo "Please delete it before moving on or utilize the existing cluster..."
  echo "kind delete clusters aimstack"
  exit 1
fi




