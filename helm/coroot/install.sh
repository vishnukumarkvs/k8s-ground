#!/bin/bash

set -euo pipefail

# Step 1: Add Coroot Helm repo
echo "👉 Adding Coroot Helm repo..."
helm repo add coroot https://coroot.github.io/helm-charts
helm repo update

# Step 2: Install Coroot Operator
echo "🚀 Installing Coroot Operator..."
helm install -n coroot --create-namespace coroot-operator coroot/coroot-operator

# Step 3: Wait for CRDs to be installed by the operator
echo "⏳ Waiting for Coroot CRD to be registered..."
until kubectl get crd coroots.coroot.com &>/dev/null; do
  echo "  ⌛ Waiting for CRD coroots.coroot.com..."
  sleep 2
done

# Step 4: Install Coroot CE with ClickHouse configuration
echo "📦 Installing Coroot Community Edition..."
helm install -n coroot coroot coroot/coroot-ce \
  --set "clickhouse.shards=2,clickhouse.replicas=2"

# Step 5: Apply a Coroot Custom Resource if you have one
# (Optional: uncomment and adjust path if needed)
# echo "📄 Applying local Coroot custom resource..."
# kubectl apply -f ./coroot/coroot-cr.yaml

echo "✅ Coroot Community Edition installed successfully!"
echo "🌐 You can now run: kubectl port-forward -n coroot service/coroot-coroot 8080:8080"
echo "   And access it at: http://localhost:8080"
