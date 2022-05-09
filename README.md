# Aimstack for ML Experiment Tracking
This repo is used as a method of testing and documenting [Aimstack](https://aimstack.io/) usage. A custom bash script is provided to use locally in [KinD](https://kind.sigs.k8s.io/) (Kubernetes-in-Docker) Cluster. Here we deploy both the Aimstack UI and the Remote Tracking capabilities on KinD. *The following has only tested on a Mac.*

*NOTE:* We will be using Remote Tracking method when writing to Aim. 


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
You may find different examples of deploying to Kubernetes within the `./kubernetes/` folder of this repo. Per the Docs, it is important to remember the importance of shared storage. You can host or share Aim anywhere that you can share the storage such as NFS or other kind of volume. We have chosen to use EFS so that we can have a volume in which can be distributed while also being multiple read/write operations at once. Please keep in mind that even though we are sharing the data on EFS, we will be using Remote tracking capabilities when writing to Aim whether it be from a local laptop, a Jupyterhub notebook running within the same Kubernetes cluster, etc...

We will be utilizing this repo and different release versions as the base of our deployment and how we manage our deployments to Kubernetes. This allows for us to use this repo as a basic template utilizing Kustomize.

Ingress is left out intentionally and it is the users responsibility to supply.


### Deploying with Kustomize
For now we support using Kustomize for deploying and managing this stack. If we get any/enough interest for different varieties we could also build a Helm Chart.


### Managing with ArgoCD

### Using with Jupyterhub

### DockerHub
Public Docker images can be found [here](https://hub.docker.com/repository/docker/wbassler/aimstack).

## Evaluating Runs
