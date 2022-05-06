# Aimstack for ML Experiment Tracking
This repo is used as a method of testing and documenting [Aimstack](https://aimstack.io/) usage. A custom bash script is provided to use locally in [KinD](https://kind.sigs.k8s.io/) (Kubernetes-in-Docker) Cluster. Here we deploy both the Aimstack UI and the Remote Tracking capabilities on KinD. 

*NOTE:* The following has only tested on a Mac.

### Prereqs
 - [KinD](https://kind.sigs.k8s.io/)

 - [Docker Desktop](https://www.docker.com/)
 
 - [Kubectl CLI](https://kubernetes.io/docs/tasks/tools/#kubectl)

 - [Kustomize CLI](https://kustomize.io)
 - Python 3.9+
 
### Python Usage
Use the following to create a virtual environment to begin using the [Aim SDK](https://aimstack.readthedocs.io/en/latest/refs/sdk.html). A requirements file has been added to make it easier to add additional packages for local development and to test on the Aimstack Server/UI. 
```
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Getting Started with Kind
As mentioned a simple script has been provided:
```
bash deploy-kind.sh
```

This script handles the necessary steps for: 
- deploying a KinD Cluster 
- building an aimstack Docker image 
- deploying the actual Aimstack Server and UI
### Using Aimstack Remote Tracking Server
Using our KinD cluster we do not tie to an Ingress so we need to use the `port-forward` from our `kubectl`. In this environment we need to have port forwarding to the server on to use Remote Tracking. Use the following in your terminal to reach Aimstack Server for Remote Tracking.
```
kubectl port-forward -n aimstack svc/aimstack 53800:53800
```

Inside our your code when you create a run be sure to then use `Run(repo="aim://localhost:53800")` to connect. 

ie:
```
# Initialize a Run
run = Run(repo="aim://localhost:53800", experiment="test_experiment")
```

*NOTE:* CTRL+C kills port forwarding.

For more information on Remote Tracking [see docs here.](https://aimstack.readthedocs.io/en/latest/using/remote_tracking.html)

### Reaching the Aimstack UI
Same applies here as using the Remote Tracking. You must `port-forward` when you want to use the UI Service. Isse the following command to reach UI from your favorite browser. 

```
kubectl port-forward -n aimstack svc/aimstack 8080:80
```

Then go to your favorite browser to: [http://locahost:8080](http://locahost:8080)

*NOTE:* CTRL+C kills port forwarding.

## Real World Usage for K8s
COMING SOON

### Deploying with Kustomize

### Managing with ArgoCD

### Using with Jupyterhub

## Evaluating Runs
