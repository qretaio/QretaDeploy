# QretaDeploy

Simple continuous deployment that syncs git repositories to Kubernetes. Built
with Kro for minimal, declarative CD pipelines.

## Dependencies

- [Kro](https://kro.run) on the cluster

## What it does

- Clones a git repository and continuously syncs it to your Kubernetes cluster
- Runs `kubectl delete` and `kubectl apply` on a configurable schedule
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

   For public repositories, you can create an empty secret:
   ```bash
   kubectl create secret generic empty-ssh-keys \
     --from-literal=id_ed25519="" \
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
     repoUrl: git@github.com:your-org/your-repo.git
     branch: main
     apply: manifests          # Folder containing Kubernetes manifests to apply
     delete: old-manifests     # Optional: Folder containing manifests to delete before apply
     interval: "30"            # Sync interval in seconds
     sshKeys: gh-deploy-key    # Secret name (required, use empty-ssh-keys for public repos)
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
3. Deletes resources from the `delete` folder (if specified)
4. Applies resources from the `apply` folder (if specified)
5. Restarts automatically when ConfigMaps change (via Reloader annotation)

## License

MIT or Apache 2
