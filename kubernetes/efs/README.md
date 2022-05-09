# EFS (NFS) Example
We will be deploying the following resources:
- Deployment: containing both the UI and Tracking server.
- Job: Initilization Job used to initialize the repo on the first run.
- PV: The EFS volume
- PVC: Claim for the EFS volume
- We will also need to `patchesStrategicMerge` the EFS claim into both our Deployment and Job.

Note the release version that we are using in the `kustomization.yaml` file (as mentioned the repo is used as a template for deploying Aimstack to Kubernetes and it might be out of date).

```
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- github.com/geekbass/aimstack?ref=v0.0.1
- pvc.yaml
- pv.yaml
# Patch in the EFS PVC
patchesStrategicMerge:
- init-job.yaml
- deployment.yaml
images:
  - name: aimstack
    newName: wbassler/aimstack
    newTag: "v0.0.1"
```
Here we need to assign your EFS server (or NFS) server in the `pv.yaml` file where we see `YOUR_NFS_SERVER_ADDRESS_HERE`.

Once we assign the server address we can deploy using Kustomize:

`kustomize build . | kubectl apply -f-`

