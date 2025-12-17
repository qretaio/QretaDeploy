# QretaDeploy

Simple continuous deployment that syncs git repositories to Kubernetes. Built
with Kro for minimal, declarative CD pipelines.

## Dependencies

- [Kro](https://kro.run) on the cluster

## What it does

- Clones a git repository and continuously syncs it to your Kubernetes cluster
- Runs `kubectl apply` on a configurable schedule (default: 30 seconds)
- Handles SSH authentication for private repositories
- Creates all necessary Kubernetes resources automatically

## Quick Start

1. **Install the QretaDeploy CRD:**
   ```bash
   kubectl apply -f manifests/QretaDeploy.yaml
   # or 
   kubectl apply -f https://raw.githubusercontent.com/qretaio/qretadeploy/main/manifests/QretaDeploy.yaml
   ```

2. **Create a deployment secret** (for private repos):
   ```bash
   kubectl create secret generic gh-deploy-key \
     --from-file=id_ed25519=~/.ssh/id_ed25519 \
     --namespace=qretadeploy
   ```

3. **Deploy your app:**
   ```bash
   kubectl apply -f examples/deploy.yaml
   # or create your own QretaDeploy resource:
   kubectl apply -f - <<EOF
   apiVersion: kro.run/v1alpha1
   kind: QretaDeploy
   metadata:
     name: my-app-cd
     namespace: qretadeploy
   spec:
     name: my-app-cd
     repoUrl: git@github.com:your-org/your-repo.git
     branch: main
     folder: manifests          # Folder containing Kubernetes manifests
     interval: "30"             # Sync interval in seconds
     sshKeys: gh-deploy-key     # Secret name (omit for public repos)
   EOF
   ```

   See [examples](examples) for more details.

## Requirements

- Kubernetes cluster
- [Kro](https://kro.run) installed
- `kubectl` access to your cluster

## How it works

QretaDeploy creates a lightweight deployment that:

1. Clones your repository using SSH or HTTPS
2. Runs in a loop, fetching the latest changes
3. Applies Kubernetes manifests from the specified folder
4. Restarts automatically when ConfigMaps change (via Reloader annotation)

## License

MIT or Apache 2
